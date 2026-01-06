import SwiftUI

struct EditTicketView: View {
    @StateObject private var viewModel: EditTicketViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isDateFocused: Bool = false
    @State private var isTimeFocused: Bool = false
    @State private var isTimeSelected: Bool = false
    
    @FocusState private var isFocused: Bool
    
    init(ticket: Ticket) {
        self._viewModel = StateObject(wrappedValue: EditTicketViewModel(ticket: ticket))
    }
    
    var body: some View {
        DGScreen(backgroundColor: .common0, isLoading: viewModel.isLoading, onClick: { isFocused = false }) {
            VStack(spacing: 0) {
                TitleBackNavBar(title: "티켓 수정하기", isDarkMode: true) {
                    Button(action: {
                        Task {
                            await viewModel.updateTicket(onSuccess: { dismiss() })
                        }
                    }) {
                        Text("완료")
                            .fontStyle(.headline2)
                            .foregroundStyle(viewModel.isUpdateButtonEnabled ? .opacityWhite850 : .opacityWhite300)
                    }
                    .disabled(!viewModel.isUpdateButtonEnabled)
                }
                .padding(.bottom, 24)
                
                ScrollView(.vertical, showsIndicators: false) {
                    EditTicketDetailContent(
                        formData: $viewModel.formData,
                        date:viewModel.setDateTimeFieldBinding(for: .date),
                        time:viewModel.setDateTimeFieldBinding(for: .time)
                    )
                }
            }
        }
        
        .overlay(alignment: .bottom) {
            if isDateFocused || isTimeFocused {
                VStack(spacing: 0) {
                    if isDateFocused {
                        DatePicker(
                            "",
                            selection: viewModel.setDateTimeFieldBinding(for: .date),
                            displayedComponents: .date
                        )
                        .onTapGesture(count: 99){}
                        .tint(.neutral300)
                        .colorScheme(.dark)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(width: 320)
                    }
                    
                    if isTimeFocused {
                        DatePicker(
                            "",
                            selection: viewModel.setDateTimeFieldBinding(for: .time),
                            displayedComponents: .hourAndMinute
                        )
                        .tint(.common100)
                        .datePickerStyle(.wheel)
                        .tint(.neutral300)
                        .colorScheme(.dark)
                        .frame(width: 320)
                    }
                }
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.opacityWhite100, lineWidth: 1)
                )
            }
        }
    }
}


// MARK: - Components
extension EditTicketView {
    @ViewBuilder
    private func dateTimeField(_ step: DateTimeStep) -> some View {
        let isFieldFocused = step == .date ? isDateFocused : isTimeFocused
        var value: String {
            if step == .date {
                viewModel.formData.date?.toyyyyMMddString() ?? "관람 일자"
            } else {
                if isTimeSelected {
                    viewModel.formData.time?.toTimeString() ?? "관람 시간"
                } else {
                    "관람 시간"
                }
            }
        }
        
        Button(action: {
            if step == .time {
                isTimeSelected = true
            }
            isDateFocused = step == .date
            isTimeFocused = step != .date
            
        }) {
            HStack {
                Text(value)
                    .fontStyle(.headline1)
                    .foregroundStyle(value.contains("관람") ? .opacityWhite300 : .neutral300)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if value.contains("관람") {
                    Image(step.rawValue)
                }
            }
            .padding(.leading, 16)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFieldFocused ? .opacityWhite600 : .opacityWhite100, lineWidth: isFieldFocused ? 1.5 : 1)
                    .background(.opacityWhite50)
            )
        }
        .contentTransition(.numericText())
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
