import Foundation
import CoreLocation

class MatchingService {
    static let shared = MatchingService()
    
    private init() {}
    
    struct MatchScore {
        let user: User
        let score: Double
        let reasons: [String]
    }
    
    func calculateMatchScores(currentUser: User, nearbyUsers: [User]) -> [MatchScore] {
        return nearbyUsers.compactMap { user in
            guard user.id != currentUser.id else { return nil }
            
            let score = calculateScore(currentUser: currentUser, otherUser: user)
            let reasons = generateMatchReasons(currentUser: currentUser, otherUser: user)
            
            return MatchScore(user: user, score: score, reasons: reasons)
        }
        .sorted { $0.score > $1.score }
    }
    
    private func calculateScore(currentUser: User, otherUser: User) -> Double {
        var score = 0.0
        
        // Interest overlap (40% weight)
        let commonInterests = Set(currentUser.interests).intersection(Set(otherUser.interests))
        let interestScore = Double(commonInterests.count) / Double(max(currentUser.interests.count, otherUser.interests.count))
        score += interestScore * 0.4
        
        // Activity level (20% weight)
        let daysSinceActive = Calendar.current.dateComponents([.day], from: otherUser.lastActive, to: Date()).day ?? 0
        let activityScore = max(0, 1.0 - Double(daysSinceActive) / 7.0)
        score += activityScore * 0.2
        
        // Distance (20% weight)
        if let currentLocation = currentUser.location,
           let otherLocation = otherUser.location {
            let distance = calculateDistance(from: currentLocation, to: otherLocation)
            let distanceScore = max(0, 1.0 - distance / 5.0) // 5km max
            score += distanceScore * 0.2
        }
        
        // Availability (20% weight)
        if otherUser.isAvailable {
            score += 0.2
        }
        
        return score
    }
    
    private func generateMatchReasons(currentUser: User, otherUser: User) -> [String] {
        var reasons: [String] = []
        
        let commonInterests = Set(currentUser.interests).intersection(Set(otherUser.interests))
        if !commonInterests.isEmpty {
            reasons.append("Both interested in \(commonInterests.joined(separator: ", "))")
        }
        
        if otherUser.isAvailable {
            reasons.append("Available to meet")
        }
        
        if let currentLocation = currentUser.location,
           let otherLocation = otherUser.location {
            let distance = calculateDistance(from: currentLocation, to: otherLocation)
            if distance < 1.0 {
                reasons.append("Less than 1 km away")
            } else {
                reasons.append(String(format: "%.1f km away", distance))
            }
        }
        
        return reasons
    }
    
    private func calculateDistance(from: GeoPoint, to: GeoPoint) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1000.0 // Convert to km
    }
}
