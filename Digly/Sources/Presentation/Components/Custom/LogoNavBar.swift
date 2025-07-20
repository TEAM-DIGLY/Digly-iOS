//
//  LogoNavBar.swift
//  digly
//
//  Created by Neoself on 4/13/25.
//


import SwiftUI

// MARK: - 기본 네비게이션 바 뷰 (로고 + 알림)
struct LogoNavBar: View {
    var body: some View {
        HStack {
            Text("로고")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            Image("alarm")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(.white)
    }
}

// MARK: - 뒤로가기 네비게이션 바
struct BackNavBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("chevron_right")
                    .resizable()
                    .rotationEffect(Angle(degrees: 180.0))
                    .frame(width: 32, height: 32)
            }
            Spacer()
        }
//        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(.white)
    }
}

// MARK: - 타이틀이 있는 뒤로가기 네비게이션 바
struct TitleBackNavBar: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("arrow_left")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.white)
    }
}

// MARK: - 드롭다운이 있는 네비게이션 바
struct DropdownNavBar: View {
    @State private var isDropdownOpen = false
    @State private var selectedTitle = "이대 신촌"
    
    var body: some View {
        HStack {
            Button(action: {
                isDropdownOpen.toggle()
            }) {
                HStack(spacing: 4) {
                    Text(selectedTitle)
                        .font(.system(size: 16, weight: .medium))
                    Image("arrow_down")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .rotationEffect(isDropdownOpen ? .degrees(180) : .degrees(0))
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image("search")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.white)
    }
}

// MARK: - 닫기 버튼이 있는 네비게이션 바
struct CloseNavBar: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Image("close")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.white)
    }
}

// MARK: - 네비게이션 바 미리보기
struct NavBarPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            LogoNavBar()
            BackNavBar()
            TitleBackNavBar(title: "페이지명")
            DropdownNavBar()
            CloseNavBar(title: "페이지명")
        }
    }
}

#Preview {
    NavBarPreview()
}