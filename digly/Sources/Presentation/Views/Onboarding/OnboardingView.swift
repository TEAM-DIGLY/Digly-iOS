import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("OnboardingView")
            
            NavigationLink(destination: CreateAccountView()) {
                Text("애플 회원가입")
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.neutral5)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
        .padding()
    }
}
