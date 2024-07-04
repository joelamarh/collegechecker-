//
//  AttendaceList-ViewModel.swift
//  DNADashboard
//
//  Created by Joel Amarh on 11/04/2023.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import Foundation
import MapKit
import SwiftUI

extension AttendsListView {
    class AttendanceListViewModel: ObservableObject {
        @Published var attendanceList: [AttendanceRecord] = []
        private var database = Database.database().reference()

        init() {
            database.child("users").observe(.value) { snapshot in
                var records: [AttendanceRecord] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let record = AttendanceRecord(snapshot: data) {
                        records.append(record)
                    }
                }
                self.attendanceList = records
            }
        }
    }

    struct AttendanceRecord: Identifiable {
        var id: UUID = .init()
        var userName: String
        var bootAttended: String

        init?(snapshot: DataSnapshot) {
            guard let data = snapshot.value as? [String: Any],
                  let userName = data["name"] as? String,
                  let bootAttended = data["bootAttended"] as? String else {
                return nil
            }
            self.userName = userName
            self.bootAttended = bootAttended
        }
    }
}
