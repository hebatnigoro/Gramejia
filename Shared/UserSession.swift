import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession()
    @Published var currentUser: User?
    private init() {}
}
