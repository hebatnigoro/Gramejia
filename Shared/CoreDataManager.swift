
import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "mmz")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
            self.createDummyDataIfNeeded() // Add dummy data if needed
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Dummy Data Creation
    private func createDummyDataIfNeeded() {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        do {
            let books = try context.fetch(fetchRequest)
            if books.isEmpty {
                createDummyBooks()
            }
        } catch {
            print("Error checking for existing books: \(error.localizedDescription)")
        }
    }

    private func createDummyBooks() {
        let dummyBooks = [
            (title: "Swift Programming", author: "Apple Inc.", description: "Learn Swift programming with Apple's official guide.", price: 29.99, quantity: 5, imageName: "swift"),
            (title: "Clean Code", author: "Robert C. Martin", description: "A handbook of agile software craftsmanship.", price: 39.99, quantity: 3, imageName: "cleancode"),
            (title: "Bumi Manusia", author: "Pramoedya Ananta Toer", description: "Kisah perjuangan Minke dalam zaman kolonial Belanda.", price: 13.99, quantity: 3, imageName: "bumimanusia"),
            (title: "Negeri 5 Menara", author: "Ahmad Fuadi", description: "Perjalanan inspiratif menimba ilmu di pesantren.", price: 14.99, quantity: 2, imageName: "negeri5"),
            (title: "Laskar Pelangi", author: "Andrea Hirata", description: "Kisah perjuangan anak-anak Belitung dalam menggapai mimpi.", price: 21.99, quantity: 4, imageName: "laskar"),
            (title: "Rich Dad Poor Dad", author: "Robert T. Kiyosaki", description: "Pelajaran tentang keuangan dari dua sudut pandang ayah.", price: 12.99, quantity: 6, imageName: "richdad"),
            (title: "Filosofi Teras", author: "Henry Manampiring", description: "Filosofi Yunani-Romawi yang relevan di masa modern.", price: 14.99, quantity: 3, imageName: "filosofiteras"),
            (title: "Sebuah Seni untuk Bersikap Bodo Amat", author: "Mark Manson", description: "Pendekatan kontradiktif untuk hidup yang baik.", price: 19.99, quantity: 5, imageName: "bodoamat"),
            (title: "Cracking the Coding Interview", author: "Gayle Laakmann McDowell", description: "189 programming interview questions and solutions.", price: 39.99, quantity: 5, imageName: "cracking"),
            (title: "Artificial Intelligence: A Modern Approach", author: "Stuart Russell & Peter Norvig", description: "Comprehensive introduction to AI concepts.", price: 79.99, quantity: 2, imageName: "ai")
        ]


        for book in dummyBooks {
            let newBook = Book(context: context)
            newBook.id = UUID()
            newBook.title = book.title
            newBook.author = book.author
            newBook.dezcription = book.description // Fix: Ensure attribute name matches Core Data
            newBook.price = book.price
            newBook.quantity = Int16(book.quantity)
            newBook.imageName = book.imageName
        }

        do {
            try context.save()
            print("Dummy books with price and quantity created successfully!")
        } catch {
            print("Error saving dummy books: \(error.localizedDescription)")
        }
    }

    // MARK: - Transactions
    func saveTransaction(totalPrice: Double, books: [Book]) {
        let transaction = Tranzaction(context: context)
        transaction.id = UUID()
        transaction.date = Date()
        transaction.totalPrice = totalPrice
        transaction.items = books.map { $0.title ?? "Untitled" }.joined(separator: ", ")

        do {
            try context.save()
            print("Transaction saved successfully!")
        } catch {
            print("Error saving transaction: \(error.localizedDescription)")
        }
    }

    func fetchTransactions() -> [Tranzaction] {
        let fetchRequest: NSFetchRequest<Tranzaction> = Tranzaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Tranzaction.date, ascending: false)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching transactions: \(error.localizedDescription)")
            return []
        }
    }
}
