//
//  CustomButton.swift
//  DNADashboard
//
//  Created by Joel Amarh on 07/03/2023.
//

import SwiftUI

struct CustomButton: View {

    var body: some View {
        Button(action: {}) {
            HStack {
                Spacer()
                Text("login_screen_login_button_title")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding()
        .background(.black)
        .cornerRadius(12)
        .padding()
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
