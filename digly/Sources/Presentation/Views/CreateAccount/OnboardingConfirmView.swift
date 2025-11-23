import SwiftUI
import Lottie
struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResult
    let accessToken: String
    let refreshToken: String
    let diglyType: DiglyType
    @State private var isLoading = false
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isLoading: isLoading) {
            ZStack{
//                LottieView(name: "EMYc4sGwq6", bundle: .main)
//                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
//                    .frame(width: 200, height: 200)
                
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
