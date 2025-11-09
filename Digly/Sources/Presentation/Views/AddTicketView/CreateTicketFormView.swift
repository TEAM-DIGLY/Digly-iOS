import SwiftUI

struct CreateTicketFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateTicketViewModel

    @State private var isDateFocused: Bool = false
    @State private var isTimeFocused: Bool = false
    @State private var isTimeSelected: Bool = false
    @FocusState private var isFocused: Bool

    var onNavigateToEndTicket: ((CreateTicketFormData) -> Void)?

    init(onNavigateToEndTicket: ((CreateTicketFormData) -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: CreateTicketViewModel())
        self.onNavigateToEndTicket = onNavigateToEndTicket
    }
    
    var body: some View {
        DGScreen(
            backgroundColor: .common0,
            onClick: { isFocused = false }
        ) {
            BackNavWithProgress(
                percentage: viewModel.progressPercentage,
                title: "티켓 추가하기",
                onBackTapped: {
                    if viewModel.currentStep == .title {
                        dismiss()
                    } else {
                        viewModel.moveToPreviousStep()
                    }
                },
                onNextTapped: {
                    viewModel.moveToNextStep()
                },
                isNextDisabled: !viewModel.isNextButtonEnabled
            )
            .padding(.bottom, 24)
            
            contentSection
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal, 24)
            
            Spacer()
        }

        .animation(.mediumSpring, value: viewModel.currentStep)
        .animation(.mediumSpring, value: isDateFocused)
        .animation(.mediumSpring, value: isTimeFocused)
        .animation(.mediumSpring, value: viewModel.dateTimeStep)
        .onAppear {
            viewModel.onTicketCreated = { ticketData in
                onNavigateToEndTicket?(ticketData)
            }
        }
        .onChange(of: viewModel.formData.date) { _, newDate in
            guard newDate != nil else { return }
            isDateFocused = false
            isTimeFocused = true
            isTimeSelected = true
            viewModel.dateTimeStep = .time
        }
    }
}

// MARK: - Components
extension CreateTicketFormView {
    private var labelSection: some View {
        HStack(spacing: 4) {
            Text(viewModel.currentStep.getFormattedTitle(with: viewModel.formData.showName))
                .fontStyle(.label2)
                .foregroundStyle(.neutral300)
            
            if viewModel.currentStep != .ticketDetails {
                Text("*")
                    .fontStyle(.label2)
                    .foregroundStyle(.error)
            }
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        switch viewModel.currentStep {
        case .title:
            labelSection
                .padding(12)
            textFieldSection(for: .title)
        case .dateTime:
            labelSection
                .padding(12)
            dateTimeSection
        case .venue:
            labelSection
                .padding(12)
            textFieldSection(for: .venue)
        case .ticketDetails:
            ticketDetailsSection
        }
    }
    
    @ViewBuilder
    private func textFieldSection(for type: CreateTicketStep) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            DGTextField(
                text: viewModel.setFieldBinding(for: type),
                placeholder: type.placeholderText,
                placeholderColor: .opacityWhite300,
                backgroundColor: .opacityWhite50,
                borderColor: .opacityWhite100,
                cursorColor: .common100,
                isFocused: $isFocused,
                onClear: {}
            )
            .focused($isFocused)
            .onAppear {
                isFocused = true
            }
            
            if !viewModel.searchResults.isEmpty && isFocused {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(viewModel.searchResults, id: \.self) { searchResult in
                            Button(action: {
                                isFocused = false
                                viewModel.updateValueOf(type, searchResult)
                            }) {
                                Text(searchResult)
                                    .fontStyle(.body2)
                                    .foregroundStyle(.opacityWhite850)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 44)
                            }
                            
                            if searchResult != viewModel.searchResults.last {
                                Divider()
                                    .background(.opacityWhite300)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxHeight: 200)
            }
        }
        .background(.opacityWhite50, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? .opacityWhite600 : .opacityWhite100, lineWidth: isFocused ? 1.5 : 1)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                dateTimeField(.date)
                dateTimeField(.time)
            }
            
            bottomPickerSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
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
            viewModel.dateTimeStep = step
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
    
    private var ticketDetailsSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                formFieldView(
                    label: "극 제목",
                    value: viewModel.formData.showName,
                    isRequired: true
                )
                
                HStack(spacing: 20) {
                    formFieldView(
                        label: "관람 일시",
                        value: viewModel.formData.date?.toyyyyMMddString() ?? "관람 일자",
                        isRequired: true
                    )
                    
                    formFieldView(
                        label: "",
                        value: viewModel.formData.time?.toTimeString() ?? "관람 시간",
                        isRequired: false
                    )
                }
                
                formFieldView(
                    label: "관람 장소",
                    value: viewModel.formData.place,
                    isRequired: true
                )
                
                VStack(spacing: 34) {
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("(선택) 좌석 번호")
                            .fontStyle(.label2)
                            .foregroundStyle(.neutral300)
                        
                        TextField("ex) a열 j 32번", text: Binding(
                            get: { viewModel.formData.seatNumber },
                            set: { viewModel.updateSeatLocation($0) }
                        ))
                        .focused($isFocused)
                        .fontStyle(.headline1)
                        .foregroundStyle(viewModel.formData.seatNumber.isEmpty ? .neutral400 : .neutral100)
                        .padding(.horizontal, 16)
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
                
                    VStack(alignment: .leading, spacing: 12) {
                        Text("(선택) 티켓 가격")
                            .fontStyle(.label2)
                            .foregroundStyle(.neutral300)
                        
                        TextField("", text: Binding(
                            get: { String(viewModel.formData.price) },
                            set: { viewModel.updateTicketPrice(Int($0) ?? -1) }
                        ))
                        .focused($isFocused)
                        .keyboardType(.numberPad)
                        .fontStyle(.headline1)
                        .padding(.horizontal, 16)
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
                        .foregroundStyle(.neutral300)
                    
                    if isRequired {
                        Text("*")
                            .fontStyle(.label2)
                            .foregroundStyle(.error)
                    }
                }
            }
            
            Text(value)
                .fontStyle(.headline1)
                .foregroundStyle(.neutral100)
                .padding(.horizontal, 16)
                .frame(height: 57)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private var minusButton: some View {
        Button(action: {
            if let current = Int(viewModel.formData.seatNumber), current > 1 {
                viewModel.updateSeatNumber(String(current - 1))
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
            if let current = Int(viewModel.formData.seatNumber) {
                viewModel.updateSeatNumber(String(current + 1))
            }
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
            get: { viewModel.formData.seatNumber },
            set: { viewModel.updateSeatNumber($0) }
        ))
        .fontStyle(.headline1)
        .foregroundStyle(.neutral400)
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
    }
    
}


#Preview {
    CreateTicketFormView()
}
