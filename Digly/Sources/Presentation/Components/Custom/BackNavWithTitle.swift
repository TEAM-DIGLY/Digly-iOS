import SwiftUI

struct BackNavWithTitle<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String?
    let backAction: (() -> Void)?
    let rightContent: (() -> Content)?
    
    init(
        title: String,
        backAction: (() -> Void)?,
        @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
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
                        .foregroundStyle(.neutral5)
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
                    .foregroundStyle(.neutral5)
            }
        }
        .frame(height: 48)
        .background(.common100)
    }
}

// MARK: - BackNavWithTitle 확장 (rightContent 없는 경우)
extension BackNavWithTitle where Content == EmptyView {
    init(title: String,_ backAction: (() -> Void)? = nil) {
        self.title = title
        self.backAction = backAction
        self.rightContent = nil
    }
}

// MARK: - BackNavWithTitle 확장 (rightContent 없는 경우)
extension BackNavWithTitle {
    init(
        title: String,
         @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
        self.backAction = nil
        self.rightContent = rightContent
    }
}

