import SwiftUI

struct CreateTicketFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateTicketViewModel()
    @State private var isDateFocused: Bool = false
    @State private var isTimeFocused: Bool = false
    @State private var isTimeSelected: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        DGScreen(backgroundColor: .common0, onClick: { isFocused = false }) {
            BackNavWithProgress(
                percentage: viewModel.progressPercentage,
                title: "티켓 추가하기",
                onBackTapped: {
                    if viewModel.currentStep == .title {
                        dismiss()
                    } else {
                        viewModel.moveToPreviousStep()
                    }
                }
            )
            .padding(.bottom, 24)
            
            contentSection
                .padding(.horizontal, 24)
            
            Spacer()
            
            nextButton
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
        }

        .animation(.mediumSpring, value: viewModel.currentStep)
        .animation(.mediumSpring, value: isDateFocused)
        .animation(.mediumSpring, value: isTimeFocused)
        .animation(.mediumSpring, value: viewModel.dateTimeStep)
    }
}

// MARK: - Components
extension CreateTicketFormView {
    private var labelSection: some View {
        HStack(spacing: 4) {
            Text(viewModel.currentStep.getFormattedTitle(with: viewModel.formData.showName))
                .fontStyle(.label2)
                .foregroundStyle(.neutral65)
            
            if viewModel.currentStep != .ticketDetails {
                Text("*")
                    .fontStyle(.label2)
                    .foregroundStyle(.error)
            }
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(alignment: .leading) {
            labelSection
                .padding(.leading, 12)
            
            switch viewModel.currentStep {
            case .title:
                textFieldSection(for: .title)
            case .dateTime:
                dateTimeSection
            case .venue:
                textFieldSection(for: .venue)
            case .ticketDetails:
                ticketDetailsSection
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    @ViewBuilder
    private func textFieldSection(for type: CreateTicketStep) -> some View {
        let isExpanded = !viewModel.searchResults.isEmpty && isFocused
        
        VStack(alignment: .leading, spacing: 12) {
            DGTextField(
                text: viewModel.setFieldBinding(for: type),
                placeholder: type.placeholderText,
                placeholderColor: .opacityWhite65,
                backgroundColor: .opacityWhite95,
                borderColor: .opacityWhite85,
                cursorColor: .common100,
                isFocused: $isFocused,
                onClear: {
                    viewModel.isSelected = false
                }
            )
            .focused($isFocused)
            .onAppear {
                isFocused = true
            }
            
            if isExpanded {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(viewModel.searchResults, id: \.self) { searchResult in
                            Button(action: {
                                viewModel.isSelected = true
                                isFocused = false
                                viewModel.updateValueOf(type, searchResult)
                            }) {
                                Text(searchResult)
                                    .fontStyle(.body2)
                                    .foregroundStyle(.opacityWhite5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 44)
                            }
                            
                            if searchResult != viewModel.searchResults.last {
                                Divider()
                                    .background(.opacityWhite65)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxHeight: 200)
            }
        }
        .background(.opacityWhite95, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? .opacityWhite35 : .opacityWhite85, lineWidth: isFocused ? 1.5 : 1)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                dateTimeField(.date)
                dateTimeField(.time)
            }
            
            Text("선택한 날짜와 시간을 확인해주세요")
                .fontStyle(.body2)
                .foregroundStyle(.neutral45)
                .padding(.leading, 8)
            
            bottomPickerSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func dateTimeField(_ step: DateTimeStep) -> some View {
        let isFieldFocused = step == .date ? isDateFocused : isTimeFocused
        var value: String {
            if step == .date {
                viewModel.formData.performanceDate?.toyyyyMMddString() ?? "관람 일자"
            } else {
                if isTimeSelected {
                    viewModel.formData.performanceTime?.toTimeString() ?? "관람 시간"
                } else {
                    "관람 시간"
                }
            }
        }
        
        VStack(alignment: .leading, spacing: 6) {
            Text(step.labelText)
                .fontStyle(.body1)
                .foregroundStyle(.opacityWhite65)
                .padding(.leading, 8)
            
            Button(action: {
                if step == .time {
                    isTimeSelected = true
                }
                isDateFocused = step == .date
                isTimeFocused = step != .date
                viewModel.dateTimeStep = step
            }) {
                HStack {
                    Text(value)
                        .fontStyle(.headline1)
                        .foregroundStyle(.neutral65)
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
                        .stroke(isFieldFocused ? .opacityWhite35 : .opacityWhite85, lineWidth: isFieldFocused ? 1.5 : 1)
                        .background(.opacityWhite95)
                )
            }
        }
        .contentTransition(.numericText())
    }

    @ViewBuilder
    private var bottomPickerSection: some View {
        if isDateFocused || isTimeFocused {
            VStack(spacing: 0) {
                if isDateFocused {
                    DatePicker(
                        "",
                        selection: viewModel.setDateTimeFieldBinding(for: .date),
                        displayedComponents: .date
                    )
                    .onTapGesture(count: 99){}
                    .tint(.neutral65)
                    .colorScheme(.dark)
                    .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                if isTimeFocused {
                    DatePicker(
                        "",
                        selection: viewModel.setDateTimeFieldBinding(for: .time),
                        displayedComponents: .hourAndMinute
                    )
                    .tint(.common100)
                    .datePickerStyle(.wheel)
                    .tint(.neutral65)
                    .colorScheme(.dark)
                }
            }
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.opacityWhite85, lineWidth: 1)
            )
        }
    }
    
    private var ticketDetailsSection: some View {
        VStack(spacing: 34) {
            formFieldView(
                label: "극 제목",
                value: viewModel.formData.showName,
                isRequired: true
            )
            
            HStack(spacing: 20) {
                formFieldView(
                    label: "관람 일시",
                    value: viewModel.formData.performanceDate?.toyyyyMMddString() ?? "관람 일자",
                    isRequired: true
                )
                
                formFieldView(
                    label: "",
                    value: viewModel.formData.performanceTime?.toTimeString() ?? "관람 시간",
                    isRequired: false
                )
            }
            
            // Venue info - 관람 장소
            formFieldView(
                label: "관람 장소",
                value: viewModel.formData.venueName,
                isRequired: true
            )
            
            // Additional details
            VStack(spacing: 34) {
                // Seat counter - 관람 횟수
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        Text("(선택) 관람 횟수")
                            .fontStyle(.label2)
                            .foregroundStyle(.neutral65)
                    }
                    
                    HStack(spacing: 12) {
                        minusButton
                        seatCounterTextField
                        plusButton
                    }
                }
                
                // Seat location - 좌석 번호
                VStack(alignment: .leading, spacing: 12) {
                    Text("(선택) 좌석 번호")
                        .fontStyle(.label2)
                        .foregroundStyle(.neutral65)
                    
                    TextField("ex) a열 j 32번", text: Binding(
                        get: { viewModel.formData.seatLocation },
                        set: { viewModel.updateSeatLocation($0) }
                    ))
                    .fontStyle(.headline1)
                    .foregroundStyle(viewModel.formData.seatLocation.isEmpty ? .neutral55 : .neutral85)
                    .padding(.horizontal, 16)
                    .frame(height: 57)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.neutral5.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.neutral85.opacity(0.15), lineWidth: 1.5)
                            )
                    )
                }
                
                // Ticket price - 티켓 가격
                VStack(alignment: .leading, spacing: 12) {
                    Text("(선택) 티켓 가격")
                        .fontStyle(.label2)
                        .foregroundStyle(.neutral65)
                    
                    TextField("ex) 00,000", text: Binding(
                        get: { viewModel.formData.ticketPrice },
                        set: { viewModel.updateTicketPrice($0) }
                    ))
                    .fontStyle(.headline1)
                    .foregroundStyle(viewModel.formData.ticketPrice.isEmpty ? .neutral55 : .neutral85)
                    .padding(.horizontal, 16)
                    .frame(height: 57)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.neutral5.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.neutral85.opacity(0.15), lineWidth: 1.5)
                            )
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func formFieldView(label: String, value: String, isRequired: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !label.isEmpty {
                HStack(spacing: 4) {
                    Text(label)
                        .fontStyle(.label2)
                        .foregroundStyle(.neutral65)
                    
                    if isRequired {
                        Text("*")
                            .fontStyle(.label2)
                            .foregroundStyle(.error)
                    }
                }
            }
            
            Text(value)
                .fontStyle(.headline1)
                .foregroundStyle(.neutral85)
                .padding(.horizontal, 16)
                .frame(height: 57)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.neutral5.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.neutral85.opacity(0.15), lineWidth: 1.5)
                        )
                )
        }
    }
    
    private var minusButton: some View {
        Button(action: {
            if let current = Int(viewModel.formData.seatNumber), current > 1 {
                viewModel.updateSeatNumber(String(current - 1))
            }
        }) {
            Image(systemName: "minus")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.neutral75)
                .frame(width: 57, height: 57)
                .background(.neutral85.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var plusButton: some View {
        Button(action: {
            if let current = Int(viewModel.formData.seatNumber) {
                viewModel.updateSeatNumber(String(current + 1))
            }
        }) {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.neutral75)
                .frame(width: 57, height: 57)
                .background(.neutral85.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var seatCounterTextField: some View {
        TextField("1", text: Binding(
            get: { viewModel.formData.seatNumber },
            set: { viewModel.updateSeatNumber($0) }
        ))
        .fontStyle(.headline1)
        .foregroundStyle(.neutral55)
        .multilineTextAlignment(.center)
        .frame(height: 57)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.neutral5.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.neutral85.opacity(0.15), lineWidth: 1.5)
                )
        )
    }
    
    private var nextButton: some View {
        DGButton(
            text: viewModel.currentStep == .ticketDetails ? "완료" : "다음으로",
            type: .primaryDark,
            disabled: !viewModel.isNextButtonEnabled
        ) {
            viewModel.moveToNextStep()
        }
    }
}


#Preview {
    CreateTicketFormView()
}
