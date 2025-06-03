import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var category: EventCategory
    var location: GeoPoint
    var startTime: Date
    var endTime: Date
    var createdBy: String
    var attendees: [String]
    var maxAttendees: Int?
    var tags: [String]
    var imageURL: String?
    var isPublic: Bool
    
    enum EventCategory: String, Codable, CaseIterable {
        case social = "Social"
        case sports = "Sports"
        case study = "Study"
        case food = "Food & Drinks"
        case entertainment = "Entertainment"
        case networking = "Networking"
        case other = "Other"
    }
}
