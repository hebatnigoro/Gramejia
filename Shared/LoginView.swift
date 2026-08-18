import SwiftUI
import CoreData

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAdmin: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var navigateToAdmin: Bool = false
    @State private var navigateToUser: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                // Title
                Text("Welcome to GRameJia")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Email Input
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Password Input
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Admin Toggle
                Toggle("Login as Admin", isOn: $isAdmin)
                    .padding(.horizontal)

                // Buttons for Login and Register
                HStack(spacing: 20) {
                    if #available(iOS 15.0, *) {
                        Button("Login") {
                            let result = validateInputs(email: email, password: password)
                            if result.success {
                                let loginResult = login(email: email, password: password, isAdmin: isAdmin)
                                if loginResult.success {
                                    if isAdmin {
                                        navigateToAdmin = true
                                    } else {
                                        navigateToUser = true
                                    }
                                } else {
                                    alertMessage = loginResult.message
                                    showAlert = true
                                }
                            } else {
                                alertMessage = result.message
                                showAlert = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        // Fallback on earlier versions
                    }

                    if #available(iOS 15.0, *) {
                        Button("Register") {
                            let result = validateInputs(email: email, password: password)
                            if result.success {
                                let registerResult = registerUser(email: email, password: password, isAdmin: isAdmin)
                                alertMessage = registerResult.message
                                showAlert = true
                            } else {
                                alertMessage = result.message
                                showAlert = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        // Fallback on earlier versions
                    }
                }

                // Navigation Links
                NavigationLink("", destination: AdminView(), isActive: $navigateToAdmin)
                NavigationLink("", destination: UserView(), isActive: $navigateToUser)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Input Validation
    func validateInputs(email: String, password: String) -> (success: Bool, message: String) {
        guard !email.isEmpty else { return (false, "Email cannot be empty.") }
        guard email.contains("@gmail.com") else { return (false, "Email must contain '@gmail.com'.") }
        guard !password.isEmpty else { return (false, "Password cannot be empty.") }
        return (true, "")
    }

    // MARK: - Login Logic
    func login(email: String, password: String, isAdmin: Bool) -> (success: Bool, message: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@ AND isAdmin == %@", email, password, NSNumber(value: isAdmin))
        do {
            let users = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let user = users.first {
                UserSession.shared.currentUser = user
                return (true, "Login successful.")
            } else {
                return (false, "Invalid credentials.")
            }
        } catch {
            return (false, "Error logging in: \(error.localizedDescription)")
        }
    }

    // MARK: - Register Logic
    func registerUser(email: String, password: String, isAdmin: Bool) -> (success: Bool, message: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try CoreDataManager.shared.context.fetch(fetchRequest)
            if users.isEmpty {
                let newUser = User(context: CoreDataManager.shared.context)
                newUser.id = UUID()
                newUser.email = email
                newUser.password = password
                newUser.isAdmin = isAdmin
                try CoreDataManager.shared.context.save()
                return (true, "Account registered successfully.")
            } else {
                return (false, "Email already exists.")
            }
        } catch {
            return (false, "Error registering user: \(error.localizedDescription)")
        }
    }
}
