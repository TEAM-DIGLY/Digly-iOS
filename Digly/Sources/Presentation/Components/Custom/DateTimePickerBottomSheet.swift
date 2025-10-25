import SwiftUI

struct DateTimePickerBottomSheet: View {
    let step: DateTimeStep
    @Binding var selectedDate: String
    @Binding var selectedTime: String
    let onNext: () -> Void
    let onClose: () -> Void
    
    @State private var tempDate: Date = Date()
    @State private var tempTime: Date = Date()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("취소") {
                    onClose()
                    dismiss()
                }
                .foregroundStyle(.neutral500)
                
                Spacer()
                
                Text(step.labelText)
                    .fontStyle(.headline1)
                    .foregroundStyle(.neutral900)
                
                Spacer()
                
                Button("다음") {
                    updateSelectedValue()
                    onNext()
                }
                .foregroundStyle(.neutral900)
                .fontWeight(.medium)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            
            Divider()
                .background(.neutral100)
            
            // Picker content
            VStack(spacing: 24) {
                if step == .date {
                    DatePicker(
                        "",
                        selection: $tempDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 400)
                    .padding(.horizontal, 24)
                } else {
                    DatePicker(
                        "",
                        selection: $tempTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 24)
            
            Spacer()
        }
        .background(.common100)
        .onAppear {
            setupInitialValues()
        }
    }
    
    private func setupInitialValues() {
        if step == .date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            if let date = dateFormatter.date(from: selectedDate) {
                tempDate = date
            }
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let time = timeFormatter.date(from: selectedTime) {
                tempTime = time
            }
        }
    }
    
    private func updateSelectedValue() {
        if step == .date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            selectedDate = formatter.string(from: tempDate)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            selectedTime = formatter.string(from: tempTime)
        }
    }
}
