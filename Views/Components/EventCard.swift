import SwiftUI

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = event.imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                    } else {
                        Color.gray.frame(height: 150)
                    }
                }
            } else {
                Color.gray.frame(height: 150)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text(event.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(event.attendees.count) going")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
