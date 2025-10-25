import SwiftUI

struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResponse
    let accessToken: String
    let refreshToken: String
    let diglyType: DiglyType
    @State private var isLoading = false
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isLoading: isLoading) {
            ZStack{
                Image("tmp")
                    .resizable()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        handleStartDigly()
                    }) {
                        Text("디글리 시작하기")
                            .fontStyle(.body2)
                            .foregroundStyle(.common100)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(.neutral900)
                            .cornerRadius(12)
                    }
                    .disabled(isLoading)
                    .opacity(isLoading ? 0.6 : 1.0)
                }
                .padding(.bottom,64)
            }
        }
    }
    
    private func handleStartDigly() {
        Task {
            isLoading = true
            
            AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name, diglyType)
            
            isLoading = false
        }
    }
}
