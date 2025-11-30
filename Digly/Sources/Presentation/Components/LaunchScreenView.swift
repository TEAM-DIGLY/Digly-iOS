import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.common100
                .ignoresSafeArea()
            
            VStack {
                Image("diglyText")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            }
        }
    }
}
