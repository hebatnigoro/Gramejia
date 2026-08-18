import SwiftUI
import CoreData

struct TransactionHistoryView: View {
    // Transactions passed as an argument from the parent view
    let transactions: [Tranzaction] // Removed @State since it's passed in

    var body: some View {
        NavigationView {
            VStack {
                if transactions.isEmpty {
                    Text("No transactions found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(transactions, id: \.id) { transaction in
                            VStack(alignment: .leading, spacing: 8) {
                                // Display date formatted
                                if #available(iOS 15.0, *) {
                                    Text("Date: \(transaction.date?.formatted() ?? "Unknown")")
                                        .font(.headline)
                                } else {
                                    Text("Date: \(transaction.date?.description ?? "Unknown")")
                                        .font(.headline)
                                }
                                // Display transaction items and price
                                Text("Items: \(transaction.items ?? "No items")")
                                    .font(.subheadline)
                                Text("Total Price: $\(String(format: "%.2f", transaction.totalPrice))")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            .padding(4)
                        }
                    }
                }
            }
            .navigationTitle("Transaction History")
        }
    }
}


// Placeholder struct to simulate Tranzaction for Preview
struct TranzactionPlaceholder: Identifiable {
    let id: UUID
    let date: Date?
    let items: String?
    let totalPrice: Double
}
