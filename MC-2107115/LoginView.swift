import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Emon-2107115's Diary")
                .font(.largeTitle).bold()
                .padding(.bottom, 8)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(8)
            }

            HStack(spacing: 12) {
                Button("Sign In") {
                    authViewModel.signIn(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(email.isEmpty || password.isEmpty)

                Button("Sign Up") {
                    authViewModel.signUp(email: email, password: password)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
