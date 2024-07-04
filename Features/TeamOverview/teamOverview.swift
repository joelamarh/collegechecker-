//
//  teamOverview.swift
//  DNADashboard
//
//  Created by Joel Amarh on 01/05/2023.
//

import SwiftUI

struct teamOverview: View {
    @ObservedObject var viewModel = TeamOverviewModel()
    var body: some View {
        List {
            ForEach(viewModel.teamOverviewList) { TeamOverviewRecord in
                HStack {
                    VStack(alignment: .leading) {
                        Text(TeamOverviewRecord.userName)
                            .font(.headline)
                        Text(TeamOverviewRecord.userStatus)
                            .font(.subheadline)
                        Text("Last updated: \(TeamOverviewRecord.lastUpdated)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    statusIndicator(isOnline: TeamOverviewRecord.online)
                }
            }
        }
    }

    @ViewBuilder
    private func statusIndicator(isOnline: Bool) -> some View {
        if isOnline {
            Circle()
                .foregroundColor(.green)
                .frame(width: 10, height: 10)
        } else {
            Circle()
                .foregroundColor(.red)
                .frame(width: 10, height: 10)
        }
    }
}

struct teamOverview_Previews: PreviewProvider {
    static var previews: some View {
        teamOverview()
    }
}
