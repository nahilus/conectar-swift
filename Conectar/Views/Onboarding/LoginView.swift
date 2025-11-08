import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var loginSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackgroundCompat.ignoresSafeArea()
                
                VStack(spacing: 28) {
                    header
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.secondarySystemBackgroundCompat)
                            .cornerRadius(12)
                        
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .padding()
                            .background(Color.secondarySystemBackgroundCompat)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(action: loginTapped) {
                        if isLoading {
                            ProgressView().tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                        } else {
                            Text("Log In")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
            .navigationBarBackButtonHidden(false)
            .navigationDestination(isPresented: $loginSuccess) {
                MainTabView()
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Text("Welcome Back 👋")
                .font(.title.bold())
            Text("Log in to continue")
                .foregroundStyle(.secondary)
        }
    }
    
    private func loginTapped() {
        isLoading = true
        APIService.shared.login(email: email, password: password) { success in
            isLoading = false
            if success {
                loginSuccess = true
            } else {
                // Handle error properly (e.g. show alert)
            }
        }
    }
}

#Preview {
    LoginView()
}
