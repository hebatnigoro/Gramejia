import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSession = UserSession.shared

    var body: some View {
        VStack(spacing: 16) {
            Image("profile_placeholder")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())

            if let user = userSession.currentUser {
                Text("Email: \(user.email ?? "N/A")")
                Text("Role: \(user.isAdmin ? "Admin" : "User")")
            } else {
                Text("No user logged in.")
            }

            Button("Logout") {
                userSession.currentUser = nil
            }
            .foregroundColor(.red)
        }
    }
}
