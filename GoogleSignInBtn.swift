//
//  GoogleSigninBtn.swift
//  DNADashboard
//
//  Created by Joel Amarh on 07/03/2023.
//

import SwiftUI

struct GoogleSignInBtn: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)

                Image("google")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .mask(Circle())
            }
        }
        .buttonStyle(.plain)
        .frame(width: 50, height: 50)
    }
}

struct GoogleSigninBtn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInBtn(action: {})
    }
}
