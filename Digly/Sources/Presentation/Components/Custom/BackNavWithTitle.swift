import SwiftUI


struct BackNavWithTitle<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String?
    let backgroundColor: Color?
    let backAction: (() -> Void)?
    let rightContent: (() -> Content)?
    
    init(
        title: String,
        backgroundColor: Color = .common100,
        backAction: (() -> Void)?,
        @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.backAction = backAction
        self.rightContent = rightContent
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 12) {
                Button(action: {
                    if let backAction {
                        backAction()
                    } else {
                        dismiss()
                    }
                }) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(backgroundColor == .common100 ? .neutral900  : .common100)
                }
                
                Spacer()
                
                if let rightContent {
                    rightContent()
                } else {
                    Color.clear
                }
            }
            
            if let title {
                Text(title)
                    .font(.headline2)
                    .foregroundStyle(backgroundColor == .common100 ? .neutral900  : .common100)
            }
        }
        .frame(height: 48)
        .background(backgroundColor)
    }
}

// MARK: - BackNavWithTitle 확장 (rightContent 없는 경우)
extension BackNavWithTitle where Content == EmptyView {
    init(
        title: String,
        backgroundColor: Color = .common100,
        _ backAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.backAction = backAction
        self.rightContent = nil
    }
}

// MARK: - BackNavWithTitle 확장 (rightContent 없는 경우)
extension BackNavWithTitle {
    init(
        title: String,
        backgroundColor: Color = .common100,
        @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.backAction = nil
        self.rightContent = rightContent
    }
}


struct BackNavWithProgress: View {
    let percentage: Double
    let title: String
    let onBackTapped: () -> Void
    let onNextTapped: () -> Void
    let isNextDisabled: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                HStack {
                    Button(action: onBackTapped) {
                        Image("chevron_left")
                            .renderingMode(.template)
                            .foregroundStyle(.common100)
                    }
                    
                    Spacer()
                    
                    Button(action: onNextTapped) {
                        Text("다음")
                            .fontStyle(.body1)
                            .foregroundStyle(isNextDisabled ? .opacityWhite500 : .common100)
                    }
                    .disabled(isNextDisabled)
                }
                .frame(height: 44)
                
                Text(title)
                    .font(.headline2)
                    .foregroundStyle(.common100)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.neutral800)
                        .frame(height: 2)
                    
                    Rectangle()
                        .fill(.neutral600)
                        .frame(width: geometry.size.width * percentage, height: 2)
                        .animation(.easeInOut(duration: 0.3), value: percentage)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 4)
        }
    }
}
