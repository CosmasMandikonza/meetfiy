import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            Text(user.fullName)
                .font(.largeTitle)
            Text(user.email)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

