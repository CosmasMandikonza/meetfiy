import SwiftUI
import Firebase

@main
struct MeetifyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    
    init() {
        FirebaseApp.configure()
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(locationViewModel)
        }
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
    }
}
