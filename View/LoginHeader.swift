//
//  LoginHeader.swift
//  DNADashboard
//
//  Created by Joel Amarh on 07/03/2023.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Text("login_screen_welcomeback_Main")
                .font(.largeTitle)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            Text("login_screen_loginGreat_message")
                .multilineTextAlignment(.center)
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
