////
///  LoginScreen.swift
///  DNADashboard
//
//  Created by Joel Amarh on 07/03/2023.
//
//
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack {
            VStack {
                LoginHeader()
                    .padding(.bottom)
                GoogleSignInBtn {
                    FireAuth.share.signWithGoogle()
                }
            }
        }
        .padding(.top, 52)
        Spacer()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
