import SwiftUI
import CoreData

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                // Set background color for the entire view
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    // Title
                    Text("Your Cart")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top)

                    // Check if the cart is empty
                    if cartManager.cart.isEmpty {
                        Text("Your cart is empty.")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .padding()
                    } else {
                        // List of Books
                        List {
                            ForEach(cartManager.cart, id: \.id) { book in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(book.title ?? "Untitled")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Price: $\(String(format: "%.2f", book.price))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Quantity: \(book.quantity)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("Total: $\(String(format: "%.2f", book.price * Double(book.quantity)))")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Button("Remove") {
                                        cartManager.removeFromCart(book)
                                    }
                                    .foregroundColor(.red)
                                }
                                .listRowBackground(Color.black) // Match list row background
                            }
                        }
                        .background(Color.black) // Set List background to black
                        .background(Color.black
                        )
                        .listRowBackground(Color.clear)
                        // Total Price Section
                        HStack {
                            Text("Total Price:")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(String(format: "%.2f", cartManager.totalPrice))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)

                        // Buy Now Button
                        Button(action: {
                            showAlert = true
                            CoreDataManager.shared.saveTransaction(
                                totalPrice: cartManager.totalPrice,
                                books: cartManager.cart
                            )
                            cartManager.clearCart()
                        }) {
                            Text("Buy Now")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Purchase Successful"),
                                message: Text("Thank you for your purchase!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
