import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let popupData: PopupData
    
    var body: some View {
        let popup = popupData.type
        
        VStack(spacing: 0) {
            Text(popup.title)
                .font(.body2)
                .foregroundColor(.opacity15)
                .padding(.bottom, 8)
            
            Text(popup.description)
                .font(.label2)
                .foregroundColor(.opacity35)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                buttonSection(popup.secondaryButtonText) {
                    hidePopup()
                }
                
                buttonSection(popup.primaryButtonText) {
                    popupData.action()
                    hidePopup()
                }
            }
            
        }
        .padding(16)
        .background(.common100, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 48)
    }
    
    private func buttonSection(_ text: String, isSub: Bool = false, action: @escaping ()-> Void)-> some View {
        Button(action: action) {
            Text(text)
                .font(.label2)
                .foregroundStyle(.opacity5)
        }
        .frame(maxWidth: .infinity, maxHeight: 44)
    }
}


#Preview {
    Preview_wrapper()
}
struct Preview_wrapper: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity( 0.3)
            
            DGPopup(
                hidePopup: {},
                popupData: PopupData(type: .updateMandatory, action: {})
            )
        }
    }
}
