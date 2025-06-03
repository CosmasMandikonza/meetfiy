import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        self.userSession = auth.currentUser
        Task { await fetchUser() }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String, username: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(
                id: result.user.uid,
                username: username,
                email: email,
                fullName: fullName,
                interests: [],
                isAvailable: true,
                privacySettings: User.PrivacySettings(),
                createdAt: Date(),
                lastActive: Date()
            )
            
            try await db.collection("users").document(result.user.uid).setData(from: user)
            self.currentUser = user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try auth.signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchUser() async {
        guard let uid = auth.currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
