import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                header

                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                    
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.secondarySystemBackgroundCompat)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button {
                    Task { await viewModel.register() }
                } label: {
                    if viewModel.isLoading {
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
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding(.top, 60)
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                OnboardingStage1()
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
