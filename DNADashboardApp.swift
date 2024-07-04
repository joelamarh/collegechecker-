import Firebase
import GoogleSignIn
import SwiftUI

@main
struct DnaDashboardApp: App {
    @AppStorage("signIn") var isSignIn = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginScreen()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            } else {
                ContentView()
            }
        }
    }
}
