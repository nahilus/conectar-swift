import SwiftUI

struct LandingView: View {
    @State private var showLogin = false
    @State private var showRegister = false
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            // ✅ If authenticated, show ContentView immediately
            if authViewModel.isAuthenticated {
                ContentView()
            } else {
                ZStack {
                    LinearGradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 36) {
                        Spacer()
                        
                        // App Logo
                        ZStack {
                            LinearGradient(colors: [Color.purple, Color.blue],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                                .frame(width: 72, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            Image(systemName: "sparkles")
                                .foregroundStyle(.white)
                                .font(.system(size: 30, weight: .semibold))
                        }
                        
                        Text("Welcome to Conectar")
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)
                        
                        Text("Connect, collaborate, and create with others who share your passion.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Button(action: { showRegister = true }) {
                                Text("Get Started")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { showLogin = true }) {
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black.opacity(0.3))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer()
                    }
                }
                // 👇 These navigate to Login/Register
                .navigationDestination(isPresented: $showLogin) {
                    LoginView(authViewModel: authViewModel)
                }
                .navigationDestination(isPresented: $showRegister) {
                    RegisterView(authViewModel: authViewModel)
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var authViewModel = AuthViewModel()
    LandingView(authViewModel: authViewModel)
}
