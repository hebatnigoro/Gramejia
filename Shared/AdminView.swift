import SwiftUI
import CoreData

struct AdminView: View {
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)]
    ) var books: FetchedResults<Book>
    
    // State variables for new book attributes
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var description: String = ""
    @State private var price: String = "" // Using String to parse into Double later
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeleteAlert = false
    @State private var selectedBook: Book? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
               

                // Input fields for adding a new book
                VStack(spacing: 12) {
                    TextField("Book Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Author", text: $author)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                // Add Book Button
                Button(action: addBook) {
                    Text("Add Book")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // List to display all books with Delete Button
                List {
                    ForEach(books, id: \.id) { book in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title ?? "Untitled")
                                    .font(.headline)
                                Text("Author: \(book.author ?? "Unknown")")
                                    .font(.subheadline)
                                Text("Price: $\(String(format: "%.2f", book.price))")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            Button(action: {
                                selectedBook = book
                                showDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
                .listStyle(PlainListStyle())

                Spacer()
            }
            .navigationTitle("Admin Panel")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Book"),
                    message: Text("Are you sure you want to delete this book?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let bookToDelete = selectedBook {
                            deleteSelectedBook(book: bookToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    // Function to add a new book to Core Data
    private func addBook() {
        guard !title.isEmpty, !author.isEmpty, !description.isEmpty, !price.isEmpty else {
            alertMessage = "All fields must be filled!"
            showAlert = true
            return
        }

        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Please enter a valid price!"
            showAlert = true
            return
        }

        let newBook = Book(context: CoreDataManager.shared.context)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.dezcription = description
        newBook.price = priceValue

        saveContext()

        // Show success message
        alertMessage = "Book successfully added!"
        showAlert = true

        // Clear input fields
        title = ""
        author = ""
        description = ""
        price = ""
    }

    // Function to delete selected books from the list
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            CoreDataManager.shared.context.delete(books[index])
        }
        saveContext()
    }

    // Function to delete specific book using Button
    private func deleteSelectedBook(book: Book) {
        CoreDataManager.shared.context.delete(book)
        saveContext()
    }

    // Save changes to Core Data
    private func saveContext() {
        do {
            try CoreDataManager.shared.context.save()
        } catch {
            alertMessage = "Failed to save data: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
