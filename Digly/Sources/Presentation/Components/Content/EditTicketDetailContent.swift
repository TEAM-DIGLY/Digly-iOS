import SwiftUI

struct EditTicketDetailContent: View {
    @Binding var formData: CreateTicketFormData
    @Binding var date: Date
    @Binding var time: Date
    
    @State private var isDateFocused: Bool = false
    @State private var isTimeFocused: Bool = false
    @State private var isTimeSelected: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            DGFormField(
                value: $formData.showName,
                label: "극 제목",
                isRequired: true
            )
            
            HStack(spacing: 16) {
                dateTimeField(.date)
                dateTimeField(.time)
            }
            
            VStack(spacing: 0) {
                if isDateFocused {
                    DatePicker(
                        "",
                        selection: $date,
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
                        selection: $time,
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
            
            
            DGFormField(
                value: $formData.place,
                label: "관람 장소",
                isRequired: true
            )
            
            
            Text("(선택) 관람 횟수")
                .fontStyle(.label2)
                .foregroundStyle(.neutral300)
            
            
            HStack(spacing: 12) {
                minusButton
                seatCounterTextField
                plusButton
            }
            
            DGFormField(
                value: $formData.seatNumber,
                label: "(선택) 좌석 번호",
                isRequired: false
            )
            
            
            Text("(선택) 티켓 가격")
                .fontStyle(.label2)
                .foregroundStyle(.neutral300)
            
            DGTextField(
                text: $formData.price,
                placeholder: "ex) 100,000",
                type: .createTicketOptional
            )
            .focused($isFocused)
            .keyboardType(.numberPad)
            
        }
        .padding(.horizontal, 24)
    }
}


// MARK: - Components
extension EditTicketDetailContent {
    @ViewBuilder
    private func dateTimeField(_ step: DateTimeStep) -> some View {
        let isFieldFocused = step == .date ? isDateFocused : isTimeFocused
        var value: String {
            if step == .date {
                formData.date?.toyyyyMMddString() ?? "관람 일자"
            } else {
                if isTimeSelected {
                    formData.time?.toTimeString() ?? "관람 시간"
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
            if formData.count > 1 {
                formData.count -= 1
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
            formData.count += 1
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
            get: { String(formData.count) },
            set: {
                if let value = Int($0), value > 0 {
                    formData.count = value
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

struct DGFormField: View {
    @Binding var value: String
    
    let label: String
    let isRequired: Bool
    
    var body: some View {
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
                text: $value,
                placeholder: "",
                type: isRequired ? .createTicket : .createTicketOptional
            )
        }
    }
}

#Preview {
    EditTicketView(ticket: Ticket.dummy)
}
