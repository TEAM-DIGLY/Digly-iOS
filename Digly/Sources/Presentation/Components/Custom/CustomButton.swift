//import SwiftUI
//
//struct CustomButton: View {
//    let action: () -> Void
//    let isLoading: Bool
//    let text: String
//    let isDisabled: Bool
//    var loadingTint: Color = .opacity60
//    var enabledBackgroundColor: Color = .blue30
//    var disabledBackgroundColor: Color = .opacity20
//    var enabledForegroundColor: Color = .opacity00
//    var disabledForegroundColor: Color = .opacity60
//    var font: Font = ._body2
//    var cornerRadius: CGFloat = 10
//    
//    var body: some View {
//        Button(action: action) {
//            if isLoading {
//                ProgressView()
//                    .frame(maxWidth: .infinity)
//                    .tint(loadingTint)
//                    .frame(height:56)
//            } else {
//                Text(text)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .font(font)
//                    .frame(height:56)
//                    .background(isDisabled ? disabledBackgroundColor : enabledBackgroundColor)
//                    .foregroundColor(isDisabled ? disabledForegroundColor : enabledForegroundColor)
//                    .cornerRadius(cornerRadius)
//            }
//        }
//        .disabled(isDisabled || isLoading)
//    }
//}
