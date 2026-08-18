import SwiftUI
import CoreData

struct UserView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch available books
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
    ) var books: FetchedResults<Book>

    // State variables
    @EnvironmentObject var cartManager: CartManager
    @State private var navigateToCart = false
    @State private var navigateToProfile = false
    @State private var showTransactionHistory = false
    @State private var transactions: [Tranzaction] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 16) {
                    // Header Section
                    HStack {
                        Text("Available Books")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()

                        // Profile Button
                        Button(action: {
                            navigateToProfile = true
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .background(
                            NavigationLink(
                                destination: ProfileView(),
                                isActive: $navigateToProfile
                            ) { EmptyView() }
                        )
                    }
                    .padding(.horizontal)

                    // Scrollable Book List with DetailView Navigation
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(books, id: \.self) { book in
                                NavigationLink(destination: DetailView(book: book)) {
                                    VStack(alignment: .center) {
                                        if let imageName = book.imageName {
                                            Image(imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 180)
                                                .cornerRadius(8)
                                        } else {
                                            Image("book_placeholder")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 180)
                                                .cornerRadius(8)
                                        }

                                        Text(book.title ?? "Untitled")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .semibold))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(width: 120)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Go to Cart Button
                    Button(action: {
                        navigateToCart = true
                    }) {
                        Text("Go to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .background(
                        NavigationLink(
                            destination: CartView(),
                            isActive: $navigateToCart
                        ) { EmptyView() }
                    )

                    // Show Transaction History
                    Button(action: {
                        transactions = CoreDataManager.shared.fetchTransactions()
                        showTransactionHistory.toggle()
                    }) {
                        Text("Transaction History")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)   
                    }
                    .padding(.horizontal)

                    Spacer()
                }

                // Transaction History Sheet
                .sheet(isPresented: $showTransactionHistory) {
                    TransactionHistoryView(transactions: transactions)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
