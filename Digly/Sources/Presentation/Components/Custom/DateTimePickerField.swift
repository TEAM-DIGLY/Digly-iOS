import SwiftUI

struct DateTimePickerField: View {
    @Binding var selectedDate: String
    @Binding var selectedTime: String
    @State private var showDatePicker: Bool = false
    @State private var showTimePicker: Bool = false
    @State private var tempDate: Date = Date()
    @State private var tempTime: Date = Date()
    
    let onDateChanged: ((String) -> Void)?
    let onTimeChanged: ((String) -> Void)?
    
    init(
        selectedDate: Binding<String>,
        selectedTime: Binding<String>,
        onDateChanged: ((String) -> Void)? = nil,
        onTimeChanged: ((String) -> Void)? = nil
    ) {
        self._selectedDate = selectedDate
        self._selectedTime = selectedTime
        self.onDateChanged = onDateChanged
        self.onTimeChanged = onTimeChanged
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Date Button
            Button(action: {
                showDatePicker = true
            }) {
                HStack {
                    Text("관람 일자")
                        .font(.body1)
                        .foregroundStyle(.neutral45)
                    
                    Image(systemName: "calendar")
                        .foregroundStyle(.neutral45)
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.neutral95)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.neutral85, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Time Button
            Button(action: {
                showTimePicker = true
            }) {
                HStack {
                    Text("관람 시간")
                        .font(.body1)
                        .foregroundStyle(.neutral45)
                    
                    Image(systemName: "clock")
                        .foregroundStyle(.neutral45)
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.neutral95)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.neutral85, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $tempDate,
                onConfirm: { date in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    selectedDate = formatter.string(from: date)
                    onDateChanged?(selectedDate)
                }
            )
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(
                selectedTime: $tempTime,
                onConfirm: { time in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    selectedTime = formatter.string(from: time)
                    onTimeChanged?(selectedTime)
                }
            )
        }
        .onAppear {
            // Initialize temp values from current selections
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            if let date = dateFormatter.date(from: selectedDate) {
                tempDate = date
            }
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let time = timeFormatter.date(from: selectedTime) {
                tempTime = time
            }
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    let onConfirm: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("날짜 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("확인") {
                        onConfirm(selectedDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    @Environment(\.dismiss) private var dismiss
    let onConfirm: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .padding()
                
                Spacer()
            }
            .navigationTitle("시간 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("확인") {
                        onConfirm(selectedTime)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @State var date = "2021.04.03"
    @State var time = "15:00"
    
    return DateTimePickerField(
        selectedDate: $date,
        selectedTime: $time
    )
    .padding()
    .background(.neutral95)
}