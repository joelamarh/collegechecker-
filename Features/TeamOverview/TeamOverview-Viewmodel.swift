//
//  TeamOverview-Viewmodel.swift
//  DNADashboard
//
//  Created by Joel Amarh on 02/05/2023.
//
import Firebase
import FirebaseDatabase
import SwiftUI

extension teamOverview {
    class TeamOverviewModel: ObservableObject {
        @Published var teamOverviewList: [TeamOverviewRecord] = []
        private let database = Database.database().reference()
        init() {
            database.child("users").observe(.value) { snapshot in
                var records: [TeamOverviewRecord] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let record = TeamOverviewRecord(snapshot: data) {
                        records.append(record)
                    }
                }
                self.teamOverviewList = records
            }
        }

        struct TeamOverviewRecord: Identifiable {

            var id: UUID = .init()
            var userName: String
            var userStatus: String
            var bootAttended: String
            var lastUpdated: Date
            var online: Bool

            init?(snapshot: DataSnapshot) {
                guard let data = snapshot.value as? [String: Any],
                      let userName = data["name"] as? String,
                      let userStatus = data["status"] as? String,
                      let bootAttended = data["bootAttended"] as? String,
                      let lastUpdatedTimestamp = data["lastUpdated"] as? TimeInterval,
                      let online = data["online"] as? Bool else {
                    return nil
                }
                self.userName = userName
                self.userStatus = userStatus
                self.bootAttended = bootAttended
                lastUpdated = Date(timeIntervalSince1970: lastUpdatedTimestamp)
                self.online = online
            }
        }
    }
}
