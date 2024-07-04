//
//  ContentView.swift
//  dnaDashboard
//
//  Created by Joel Amarh on 06/03/2023.
//

import Firebase
import FirebaseAuth
import Foundation
import GoogleSignIn
import SwiftUI

struct ContentView: View {
    let user: Firebase.User?
    let email: String
    let name: String

    let statusOptions = ["Available", "In a meeting", "On a call", "Out to lunch"]
    @State private var selected = "Available"

    var ref = Database.database().reference()

    @State private var isOffline = false
    @State private var isOnline = true

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let url = Auth.auth().currentUser?.photoURL {
                    AsyncImage(url: url) { image in
                        image.resizable(resizingMode: .stretch)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 175, height: 175)
                    .clipShape(Circle())
                    .padding(10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 4)
                }
                Text(name)
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .toolbar {

                        Button("profile_screen_logout_button_title") {
                            FireAuth.share.signout()
                        }
                    }
                Picker("Please choose", selection: $selected) {
                    ForEach(statusOptions, id: \.self) { option in
                        Text(option)
                    }
                    .onChange(of: selected) { newValue in
                        guard let userId = Auth.auth().currentUser?.uid else { return }
                        let value = ["status": newValue, "lastUpdated": Date().timeIntervalSince1970] as [String: Any]
                        ref.child("users/\(userId)").updateChildValues(value)
                    }
                }
                .pickerStyle(.segmented)
                List {
                    NavigationLink(destination: WelcomeView()) {
                        Text("Map")
                    }
                    NavigationLink(destination: AttendsListView()) {
                        Text("Boat_Attendance")
                    }
                    NavigationLink(destination: LogoGeneratorView()) {
                        Text("Logo_Creator")
                    }
                    NavigationLink(destination: teamOverview()) {
                        Text("Team_overview")
                    }
                }
                Toggle("Online/Offline", isOn: $isOnline) // Added online/offline switch button
                    .onChange(of: isOnline) { newValue in
                        if newValue {
                            setOnlineStatus()
                        } else {
                            setOfflineStatus()
                        }
                    }
            }
            .padding()
            .navigationTitle("Profile")
            WelcomeView()
        }
        .onAppear {
            setOnlineStatus()
        }
        .onDisappear {
            setOfflineStatus()
        }
    }

    private func setOnlineStatus() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let value = ["online": true, "lastSeen": Date().timeIntervalSince1970] as [String: Any]
        ref.child("users/\(userId)").updateChildValues(value)
        isOffline = false
    }

    private func setOfflineStatus() {
        if isOffline {
            return
        }
        let userId = Auth.auth().currentUser?.uid ?? ""
        let value = ["online": false, "lastUpdated": Date().timeIntervalSince1970] as [String: Any]
        ref.child("users/\(userId)").updateChildValues(value)
        isOffline = true
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
