import SwiftUI

struct TicketMenuDropdown: View {
    @Environment(\.dismiss) private var dismiss
    let onEditSelected: () -> Void
    let onDeleteSelected: () -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            VStack(spacing: 0) {
                menuItem(title: "수정하기") {
                    onEditSelected()
                    dismiss()
                }

                Divider()
                    .background(Color.opacityWhite100)

                menuItem(title: "삭제하기") {
                    onDeleteSelected()
                    dismiss()
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(hex: "222222"))
            .cornerRadius(14)
            .frame(width: 319)
            .padding(.top, 123)
            .padding(.trailing, 28)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            dismiss()
        }
    }

    private func menuItem(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.opacityWhite850)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.clear)
        }
    }
}

#Preview {
    TicketMenuDropdown(
        onEditSelected: {},
        onDeleteSelected: {}
    )
}
