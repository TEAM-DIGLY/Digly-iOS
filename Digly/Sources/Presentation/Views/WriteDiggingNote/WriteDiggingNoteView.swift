import SwiftUI

struct WriteDiggingNoteView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }

    private var navigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("arrow_left")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Text("알림함")
                .font(.headline1)
                .foregroundColor(Color("textCommon100"))
            
            Spacer()
            
            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 56) // Adjust for status bar
        .padding(.bottom, 16)
        .background(Color.white.shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4))
    }
}

