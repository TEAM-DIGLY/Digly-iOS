import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.clear
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
