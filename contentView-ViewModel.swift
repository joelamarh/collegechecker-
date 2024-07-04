//  contentView-ViewModel.swift
//  DNADashboard
//
//  Created by Joel Amarh on 14/03/2023.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseRemoteConfig
import Foundation
import MapKit
import SwiftUI

extension ContentView {
    init() {
        user = Auth.auth().currentUser
        email = user?.email ?? "N/A"
        name = user?.displayName ?? "N/A"
    }
}
