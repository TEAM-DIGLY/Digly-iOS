//
//  OnboardingView.swift
//  digly
//
//  Created by 김 형석 on 10/14/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing:24){
            Image("icon-text")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160)
                .padding(.bottom,8)
            Text("문화생활의 여운")
                .font(._title)
                .foregroundStyle(.gray60)
        }
    }
}

#Preview {
    OnboardingView()
}
