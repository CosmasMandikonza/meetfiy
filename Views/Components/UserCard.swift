import SwiftUI

struct UserCard: View {
    let user: User
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.fullName.prefix(1))
                        .font(.title2)
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.headline)
                Text(user.interests.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
