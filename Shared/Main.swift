import SwiftUI

@main
struct Main: App {
    let persistenceController = CoreDataManager.shared
    
    @StateObject private var cartManager = CartManager()

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(cartManager)
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
