import SwiftUI

struct DetailView: View {
    let book: Book
    @EnvironmentObject var cartManager: CartManager
    @State private var navigateToCart = false
    @State private var showAlert = false


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Book Cover Image
                if let imageName = book.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Image("book_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                // Book Details
                Text(book.title ?? "Untitled")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Author: \(book.author ?? "Unknown")")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text("Price: $\(String(format: "%.2f", book.price))")
                    .font(.body)
                    .foregroundColor(.green)

                Text(book.dezcription ?? "No description available.")
                    .font(.body)
                    .lineSpacing(5)
                    .foregroundColor(.white)

                // Add to Cart Button
                Button("Add to Cart") {
                    cartManager.addToCart(book)
                    showAlert = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("Successfully added to cart."),
                        dismissButton: .default(Text("OK"))
                    )
                }


                // Go to Cart Button
                Button("Go to Cart") {
                    navigateToCart = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Navigation Link to CartView
                NavigationLink("", destination: CartView(), isActive: $navigateToCart)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden(false) // Use default back button
    }
    
}
