import SwiftUI

struct OnboardingConfirmView: View {
    @ObservedObject var viewModel : CreateAccountViewModel
    
    var body: some View {
        ZStack{
            Image("tmp")
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("디글러 시작하기")
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(.neutral5)
                    .cornerRadius(12)
                    .onTapGesture {
                        viewModel.handleDone()
                    }
            }
            .padding(.bottom,64)
        }
    }
}
