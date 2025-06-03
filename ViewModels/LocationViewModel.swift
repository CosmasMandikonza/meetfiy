import Foundation
import CoreLocation
import Combine
import FirebaseAuth

class LocationViewModel: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var nearbyUsers: [User] = []
    @Published var nearbyEvents: [Event] = []
    
    private let locationManager = CLLocationManager()
    private let firebaseService = FirebaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50 // Update every 50 meters
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func fetchNearbyUsers() async {
        guard let location = userLocation else { return }
        
        do {
            nearbyUsers = try await firebaseService.fetchNearbyUsers(
                location: location,
                radius: 5.0 // 5km radius
            )
        } catch {
            print("Error fetching nearby users: \(error)")
        }
    }
    
    func updateUserLocation() async {
        guard let location = userLocation,
              let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await firebaseService.updateUserLocation(
                userId: userId,
                location: location
            )
        } catch {
            print("Error updating user location: \(error)")
        }
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        
        Task {
            await updateUserLocation()
            await fetchNearbyUsers()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        default:
            stopLocationUpdates()
        }
    }
}
