//
//  CustomToast.swift
//  ddom
//
//  Created by 김 형석 on 9/20/24.
//

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


enum ToastType {
    case googleError
    case error(String)
    
    var text: String{
        switch self {
        case .googleError:
            return "구글 로그인이 잠시 안되고 있어요. 나중에 다시 시도해주세요."
        case .error(let message):
            return message
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "exclamationmark.circle.fill"
        default:
            return "checkmark.circle.fill"
        }
    }
}
