//
//  WelcomeView.swift
//  DNADashboard
//
//  Created by Joel Amarh on 21/03/2023.
//

import MapKit
import SwiftUI
struct WelcomeView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.location, showsUserLocation: true)
                .ignoresSafeArea()
                .accentColor(Color(.systemBrown))
                .onAppear {
                    viewModel.checkiflocationServiceEnable()
                }

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("login_screen_welcomeback_Main")
                        .font(.largeTitle)

                    Text("Welcome_please_select")
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        Text("\(viewModel.status)")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .background(Color(.black))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                    }
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .padding()
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 10)
                .onDisappear {
                    viewModel.timer?.invalidate()
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
