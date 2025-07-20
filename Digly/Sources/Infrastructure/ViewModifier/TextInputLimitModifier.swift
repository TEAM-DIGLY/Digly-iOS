import SwiftUI

/// 텍스트 입력 개수 제한을 위한 뷰 수정자
struct TextInputLimitModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
    }
}
