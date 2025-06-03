import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                NavigationView {
                    LoginView()
                }
            } else {
                HomeView()
            }
        }
        .onAppear {
            // Request location permission when app launches
            Task {
                if let locationVM = (try? UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .first?
                        .delegate as? SceneDelegate)?
                    .locationViewModel {
                    locationVM.requestLocationPermission()
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(LocationViewModel())
    }
}
#endif
