//
//  ContentView.swift
//  digly
//
//  Created by 김 형석 on 10/9/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        ZStack{
            VStack {
                switch(selectedTab) {
                case 0:
                    EmptyView()
                case 1:
                    HomeView()
                default:
                    EmptyView()
                }
                
                HStack(spacing: 0) {
                    TabBarButton(image: "diggingNote", text: "digging note", isSelected: false)
                    TabBarButton(image: "home", text: "home", isSelected: true)
                    TabBarButton(image: "report", text: "report", isSelected: false)
                }
                .padding(.vertical,10)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.white)
                        .shadow(color: Color(hex:"000000").opacity(0.1), radius: 8)
                )
                .frame(width:300)
            }
            .background(Color(hex: "F6F7FF"))
        }
    }
}

struct TabBarButton: View {
    let image: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(image)
                .renderingMode(.template)
                .foregroundStyle(isSelected ? .neutral25 : .neutral65)
            
            Text(text)
                .fontStyle(.caption2)
                .foregroundStyle(isSelected ? .neutral25 : .neutral65)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState.shared)
}
