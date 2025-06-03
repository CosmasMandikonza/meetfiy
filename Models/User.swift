import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var fullName: String
    var bio: String?
    var interests: [String]
    var profileImageURL: String?
    var location: GeoPoint?
    var isAvailable: Bool
    var privacySettings: PrivacySettings
    var createdAt: Date
    var lastActive: Date
    
    struct PrivacySettings: Codable {
        var shareLocation: Bool = true
        var visibleToNearby: Bool = true
        var maxDistance: Double = 5.0 // km
    }
}

struct GeoPoint: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
