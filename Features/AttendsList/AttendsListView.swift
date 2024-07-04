import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import Foundation
import MapKit
import SwiftUI

struct AttendsListView: View {
    @ObservedObject var viewModel = AttendanceListViewModel()
    var body: some View {
        List {
            ForEach(viewModel.attendanceList) { attendanceRecord in
                HStack {
                    VStack(alignment: .leading) {
                        Text(attendanceRecord.userName)
                            .font(.headline)
                        Text(attendanceRecord.bootAttended)
                            .font(.subheadline)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AttendanceListView_Previews: PreviewProvider {
    static var previews: some View {
        AttendsListView()
    }
}
