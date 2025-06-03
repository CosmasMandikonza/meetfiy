import Foundation
import FirebaseFirestore

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private let db = Firestore.firestore()
    
    func fetchAllEvents() async {
        do {
            let snapshot = try await db.collection("events").getDocuments()
            self.events = try snapshot.documents.compactMap { doc in
                try doc.data(as: Event.self)
            }
        } catch {
            print("Error fetching events: \(error)")
        }
    }
    
    func createEvent(_ event: Event) async {
        do {
            _ = try await FirebaseService.shared.createEvent(event)
        } catch {
            print("Error creating event: \(error)")
        }
    }
}
