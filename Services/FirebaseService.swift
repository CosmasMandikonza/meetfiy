import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchNearbyUsers(location: CLLocation, radius: Double) async throws -> [User] {
        let center = location.coordinate
        let radiusInM = radius * 1000
        
        // Rough latitude/longitude delta approximations
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = center.latitude - (lat * radius)
        let lowerLon = center.longitude - (lon * radius)
        let upperLat = center.latitude + (lat * radius)
        let upperLon = center.longitude + (lon * radius)
        
        let snapshot = try await db.collection("users")
            .whereField("location.latitude", isGreaterThan: lowerLat)
            .whereField("location.latitude", isLessThan: upperLat)
            .whereField("isAvailable", isEqualTo: true)
            .getDocuments()
        
        let users = try snapshot.documents.compactMap { doc in
            try doc.data(as: User.self)
        }
        
        return users.filter { user in
            guard let userLocation = user.location else { return false }
            let userCLLocation = CLLocation(
                latitude: userLocation.latitude,
                longitude: userLocation.longitude
            )
            return location.distance(from: userCLLocation) <= radiusInM
        }
    }
    
    func updateUserLocation(userId: String, location: CLLocation) async throws {
        let geoPoint = GeoPoint(from: location)
        
        try await db.collection("users").document(userId).updateData([
            "location": [
                "latitude": geoPoint.latitude,
                "longitude": geoPoint.longitude
            ],
            "lastActive": FieldValue.serverTimestamp()
        ])
    }
    
    func createEvent(_ event: Event) async throws -> String {
        let ref = try await db.collection("events").addDocument(data: event.asDictionary())
        return ref.documentID
    }
    
    func fetchNearbyEvents(location: CLLocation, radius: Double) async throws -> [Event] {
        let center = location.coordinate
        let radiusInM = radius * 1000
        
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = center.latitude - (lat * radius)
        let upperLat = center.latitude + (lat * radius)
        
        let snapshot = try await db.collection("events")
            .whereField("location.latitude", isGreaterThan: lowerLat)
            .whereField("location.latitude", isLessThan: upperLat)
            .whereField("startTime", isGreaterThan: Date())
            .getDocuments()
        
        let events = try snapshot.documents.compactMap { doc in
            try doc.data(as: Event.self)
        }
        
        return events.filter { event in
            let eventLocation = CLLocation(
                latitude: event.location.latitude,
                longitude: event.location.longitude
            )
            return location.distance(from: eventLocation) <= radiusInM
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization
                .jsonObject(with: data, options: .allowFragments) as? [String: Any] 
        else {
            throw NSError(domain: "EncodingError", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
