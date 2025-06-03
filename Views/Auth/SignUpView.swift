import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var fullName = ""
    @State private var isSigningUp = false
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            TextField("Full Name", text: $fullName)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                isSigningUp = true
                Task {
                    await authViewModel.signUp(email: email, password: password, 
                                               username: username, fullName: fullName)
                    isSigningUp = false
                }
            }) {
                if isSigningUp {
                    ProgressView()
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(email.isEmpty || password.isEmpty || username.isEmpty || fullName.isEmpty || isSigningUp)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}
