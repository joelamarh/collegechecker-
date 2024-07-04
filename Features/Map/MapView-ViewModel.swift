//
//  WelcomeView-ViewModel.swift
//  DNADashboard
//
//  Created by Joel Amarh on 27/03/2023.
//
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseRemoteConfig
import Foundation
import MapKit
import SwiftUI

extension WelcomeView {
    final class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

        enum MapDetails {
            static let startingLocation = CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)
            static let defaultSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        }

        @Published var location = MKCoordinateRegion(center: MapDetails.startingLocation,
                                                     span: MapDetails.defaultSpan)

        private let ref = Database.database().reference()
        @Published var status = "loading"

        var locationManger: CLLocationManager?
        var timer: Timer?
        let name: String
        override init() {
            name = Auth.auth().currentUser?.displayName ?? "N/A"
            super.init()
            checkiflocationServiceEnable()
            startTimer()
        }

        func checkiflocationServiceEnable() {
            locationManger = CLLocationManager()
            locationManger!.delegate = self
        }

        private func checkLocationAuthorization() {
            guard let locationManager = locationManger else { return }
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("your_loca_restriceted")
            case .denied:
                print("your_denied_permission")
            case .authorizedAlways, .authorizedWhenInUse:
                location = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                              span: MapDetails.defaultSpan)
                pushLocationInfo()
            @unknown default:
                break
            }
        }

        private func startTimer() {
            let remoteConfig = RemoteConfig.remoteConfig()
            remoteConfig.fetchAndActivate { [weak self] _, error in
                guard error == nil else {
                    print("Error fetching config: \(error!)")
                    return
                }
                let reloadTime = remoteConfig.configValue(forKey: "reload_time").numberValue ?? NSNumber(value: 60)
                self?.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(truncating: reloadTime),
                                                   repeats: true, block: { [weak self] _ in
                                                       self?.pushLocationInfo()
                                                   })
            }
        }

        deinit {
            timer?.invalidate()
        }

        private func pushLocationInfo() {
            guard let userLocation = locationManger?.location else {
                print("User location unknown")
                return
            }

            let remoteConfig = RemoteConfig.remoteConfig()
            remoteConfig.activate { _, _ in

                let desiredLocationLatitude = remoteConfig.configValue(forKey: "desired_location_latitude")
                    .numberValue ?? NSNumber(value: 52.3676)
                let desiredLocationLongitude = remoteConfig.configValue(forKey: "desired_location_longitude")
                    .numberValue ?? NSNumber(value: 4.9041)
                let desiredLocation = CLLocation(latitude: desiredLocationLatitude.doubleValue,
                                                 longitude: desiredLocationLongitude.doubleValue)

                let distanceInMeters = userLocation.distance(from: desiredLocation)

                let userRef = self.ref.child("users")

                guard let userId = Auth.auth().currentUser?.uid else {
                    print("User_is_not_authenticated")
                    return
                }

                userRef.child(userId).observeSingleEvent(of: .value) { snapshot, _ in
                    if !snapshot.exists() {
                        userRef.child(userId).setValue(self.name)
                    } else {
                        userRef.child(userId)
                            .updateChildValues(["name": self
                                    .name])
                    }

                    let atBoot = "At Boat"
                    let outsideBoot = "Outside the boat"
                    let distanceRadius = remoteConfig.configValue(forKey: "distance_radius")
                        .numberValue ?? NSNumber(value: 600)
                    let locationStatus = distanceInMeters <= CLLocationDistance(distanceRadius) ? atBoot : outsideBoot
                    self.status = locationStatus

                    userRef.child(userId).observeSingleEvent(of: .value) { snapshot, _ in
                        if !snapshot.exists() {
                            userRef.child(userId).setValue(["name": self.name, "bootAttended": locationStatus])
                        } else {
                            userRef.child(userId).updateChildValues(["name": self.name, "bootAttended": locationStatus])
                        }
                    }
                }
            }
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.location = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
        }
    }
}
