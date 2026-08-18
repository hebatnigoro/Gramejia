import Foundation
import CoreData

class CartManager: ObservableObject {
    @Published var cart: [Book] = []

    func addToCart(_ book: Book) {
        if cart.contains(where: { $0.id == book.id }) {
            book.quantity+=1
        
        }
        else{
            book.quantity = 1
            cart.append(book)
        }
    }

    func removeFromCart(_ book: Book) {
        cart.removeAll { $0.id == book.id }
    }

    func clearCart() {
        cart.removeAll()
    }
    
    var totalPrice: Double {
           cart.reduce(0) { result, book in
               result + (book.price * Double(book.quantity))
           }
       }
}
