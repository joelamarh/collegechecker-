// FireAuth.swift
// DNADashboard
//
// Created by Joel Amarh on 08/03/2023.

import Firebase
import FirebaseAuth
import FirebaseRemoteConfig
import Foundation
import GoogleSignIn
import SwiftUI

struct FireAuth {
    static let share = FireAuth()
    private init() {}

    #if os(macOS)
    private func getPresentationRoot() -> NSWindow {
        guard let window = NSApplication.shared.windows.first else {
            fatalError("Could not get root window")
        }
        return window
    }
    #else
    private func getPresentationRoot() -> UIViewController {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let viewController = scene.windows.first?.rootViewController else {
            fatalError("Could not get root viewcontroller")
        }
        return viewController
    }
    #endif

    func signWithGoogle() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.activate { _, _ in
            let google_hosted_domain = remoteConfig.configValue(forKey: "google_hosted_domain").stringValue

            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID, serverClientID: nil, hostedDomain: google_hosted_domain,
                                          openIDRealm: nil)
            GIDSignIn.sharedInstance.configuration = config

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: getPresentationRoot()) { result, error in
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    // handle the error case
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                    } else {
                        print("Error signing in")
                    }
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { _, error in
                    guard error == nil else {
                        return
                    }
                    print("SignIn")
                    UserDefaults.standard.set(true, forKey: "signIn")
                }
            }
        }
    }

    func signout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "signIn")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}
