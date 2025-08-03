import SwiftUI

struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResponse
    let accessToken: String
    let refreshToken: String
    @State private var isLoading = false
    
    var body: some View {
        ZStack{
            Image("tmp")
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.bottom, 16)
                }
                
                Button(action: {
                    handleStartDigly()
                }) {
                    Text("디글리 시작하기")
                        .fontStyle(.body2)
                        .foregroundStyle(.common100)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.neutral5)
                        .cornerRadius(12)
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1.0)
            }
            .padding(.bottom,64)
        }
    }
    
    private func handleStartDigly() {
        Task {
            isLoading = true
            
            // signIn에서 받은 토큰과 signUp에서 받은 사용자 정보로 최종 로그인
            AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name)
            
            isLoading = false
        }
    }
}
