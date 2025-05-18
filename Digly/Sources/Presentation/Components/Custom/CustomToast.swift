import SwiftUI
import Foundation

struct CustomToast: View {
    let toastData: ToastType
    
    var body: some View {
        HStack (spacing:8){
            Image(systemName: toastData.icon)
                .fontStyle(.body2)
                .foregroundStyle(.neutral75)
            
            Text(toastData.text)
                .font(.body2)
        }
        .frame(width: 300,alignment: .leading)
        .padding()
        .background(.neutral35)
        .foregroundStyle(.neutral65)
        .cornerRadius(8)
        .shadow(color: .neutral65.opacity(0.2), radius: 16)
    }
}

