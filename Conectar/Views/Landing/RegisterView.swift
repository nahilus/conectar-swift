import SwiftUI
import Combine

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                header

                VStack(spacing: 16) {
                    TextField("Email", text: $authViewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $authViewModel.password)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                    
                    SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button {
                    Task { await authViewModel.register() }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView().tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                .disabled(authViewModel.email.isEmpty || authViewModel.password.isEmpty)
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding(.top, 60)
            .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
                OnboardingContainerView()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("Create your account ✨")
                .font(.title.bold())
            Text("Join the community and start collaborating")
                .foregroundStyle(.secondary)
        }
    }
}
