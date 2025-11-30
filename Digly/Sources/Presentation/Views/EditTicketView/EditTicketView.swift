import SwiftUI

struct EditTicketView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditTicketViewModel
    @FocusState private var isFocused: Bool

    var onTicketUpdated: ((Ticket) -> Void)?

    init(ticket: Ticket, onTicketUpdated: ((Ticket) -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: EditTicketViewModel(ticket: ticket))
        self.onTicketUpdated = onTicketUpdated
    }

    var body: some View {
        DGScreen(
            backgroundColor: .common0,
            isLoading: viewModel.isLoading,
            onClick: { isFocused = false }
        ) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.bottom, 24)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        formFieldView(
                            label: "극 제목",
                            binding: $viewModel.formData.showName,
                            placeholder: "ex) 프랑켄슈타인",
                            isRequired: true
                        )

                        dateTimeSection

                        formFieldView(
                            label: "관람 장소",
                            binding: $viewModel.formData.place,
                            placeholder: "ex) 블루스퀘어 신한카드홀",
                            isRequired: true
                        )

                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("(선택) 관람 횟수")
                                    .fontStyle(.label2)
                                    .foregroundStyle(.neutral300)
                            }

                            HStack(spacing: 12) {
                                minusButton
                                seatCounterTextField
                                plusButton
                            }
                        }

                        formFieldView(
                            label: "(선택) 좌석 번호",
                            binding: $viewModel.formData.seatNumber,
                            placeholder: "ex) a열 j 32번",
                            isRequired: false
                        )

                        VStack(alignment: .leading, spacing: 12) {
                            Text("(선택) 티켓 가격")
                                .fontStyle(.label2)
                                .foregroundStyle(.neutral300)

                            DGTextField(
                                text: Binding(
                                    get: { viewModel.formData.price == -1 ? "" : String(viewModel.formData.price) },
                                    set: { viewModel.updateTicketPrice(Int($0) ?? -1) }
                                ),
                                placeholder: "ex) 100,000",
                                type: .createTicketOptional
                            )
                            .focused($isFocused)
                            .keyboardType(.numberPad)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onAppear {
            viewModel.onTicketUpdated = { ticket in
                onTicketUpdated?(ticket)
                dismiss()
            }
        }
    }
}

// MARK: - Components
extension EditTicketView {
    private var headerSection: some View {
        TitleBackNavBar(title: "티켓 수정하기", isDarkMode: true) {
            Button(action: {
                viewModel.updateTicket()
            }) {
                Text("완료")
                    .fontStyle(.headline2)
                    .foregroundStyle(viewModel.isUpdateButtonEnabled ? .opacityWhite850 : .opacityWhite300)
            }
            .disabled(!viewModel.isUpdateButtonEnabled)
        }
    }

    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("관람 일시")
                    .fontStyle(.label2)
                    .foregroundStyle(.neutral300)

                Text("*")
                    .fontStyle(.label2)
                    .foregroundStyle(.error)
            }

            HStack(spacing: 20) {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.formData.date ?? Date() },
                        set: { viewModel.formData.updateDate(from: $0) }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()
                .tint(.neutral300)
                .colorScheme(.dark)
                .frame(maxWidth: .infinity)
                .frame(height: 57)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.neutral900.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.neutral100.opacity(0.15), lineWidth: 1.5)
                        )
                )

                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.formData.time ?? Date() },
                        set: { viewModel.formData.updateTime(from: $0) }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .tint(.neutral300)
                .colorScheme(.dark)
                .frame(maxWidth: .infinity)
                .frame(height: 57)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.neutral900.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.neutral100.opacity(0.15), lineWidth: 1.5)
                        )
                )
            }
        }
    }

    @ViewBuilder
    private func formFieldView(label: String, binding: Binding<String>, placeholder: String, isRequired: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text(label)
                    .fontStyle(.label2)
                    .foregroundStyle(.neutral300)

                if isRequired {
                    Text("*")
                        .fontStyle(.label2)
                        .foregroundStyle(.error)
                }
            }

            DGTextField(
                text: binding,
                placeholder: placeholder,
                type: isRequired ? .createTicket : .createTicketOptional
            )
            .focused($isFocused)
        }
    }

    private var minusButton: some View {
        Button(action: {
            if viewModel.formData.count > 1 {
                viewModel.formData.count -= 1
            }
        }) {
            Image(systemName: "minus")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.neutral200)
                .frame(width: 57, height: 57)
                .background(.neutral100.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var plusButton: some View {
        Button(action: {
            viewModel.formData.count += 1
        }) {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.neutral200)
                .frame(width: 57, height: 57)
                .background(.neutral100.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var seatCounterTextField: some View {
        TextField("1", text: Binding(
            get: { String(viewModel.formData.count) },
            set: {
                if let value = Int($0), value > 0 {
                    viewModel.formData.count = value
                }
            }
        ))
        .fontStyle(.headline1)
        .foregroundStyle(.neutral100)
        .multilineTextAlignment(.center)
        .frame(height: 57)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.neutral900.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.neutral100.opacity(0.15), lineWidth: 1.5)
                )
        )
        .keyboardType(.numberPad)
    }
}

#Preview {
    EditTicketView(ticket: Ticket.dummy)
}
