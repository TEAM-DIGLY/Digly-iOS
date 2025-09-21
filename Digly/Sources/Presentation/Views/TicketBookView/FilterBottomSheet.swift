import SwiftUI

enum FilterType: String, CaseIterable {
    case month = "월별"
    case threeMonth = "3개월"
    case custom = "직접입력"
}

struct FilterBottomSheet: View {
    @Binding var startedDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFilterType: FilterType = .month
    @State private var tempStartDate: Date = Date()
    @State private var tempEndDate: Date = Date()
    @State private var datePickerType: DatePickerType = .start
    
    @State private var showDatePicker = true
    @State private var isStartDateFocused = false
    @State private var isEndDateFocused = false
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    enum DatePickerType {
        case start, end
    }

    private var isApplyButtonEnabled: Bool {
        switch selectedFilterType {
        case .month:
            // 월별: 년도와 월이 유효한 범위인지 확인
            return yearValues.contains(selectedYear) && monthValues.contains(selectedMonth)

        case .threeMonth:
            // 3개월: 항상 활성화 (고정 로직이므로)
            return true

        case .custom:
            // 직접입력: 시작날짜가 종료날짜보다 이전이거나 같은지 확인
            return tempStartDate <= tempEndDate
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("close")
                }
                .frame(maxWidth: .infinity, alignment:. trailing)
                
                Text("관람기간 선택")
                    .fontStyle(.headline2)
                    .foregroundStyle(.common100)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 24)
            
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filterType in
                    filterButton(for: filterType)
                }
            }
            .padding(.horizontal, 24)
            
            if showDatePicker {
                datePickerSection
                    .padding(.top, 16)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            DGButton(text: "적용하기", type: .primaryDark, disabled: !isApplyButtonEnabled, onClick: applyFilter)
                .padding(.horizontal, 24)
        }
        .onAppear {
            setupInitialDates()
        }
    }

    @ViewBuilder
    private func filterButton(for filterType: FilterType) -> some View {
        Button(action: {
            selectedFilterType = filterType
            handleFilterTypeSelection(filterType)
        }) {
            Text(filterType.rawValue)
                .fontStyle(.body2)
                .foregroundStyle(selectedFilterType == filterType ? .common100 : .opacityWhite45)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    selectedFilterType == filterType ?
                        .pMid : .clear, in: RoundedRectangle(cornerRadius: 16)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.opacityWhite85, lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private var datePickerSection: some View {
        VStack(spacing: 16) {
            if selectedFilterType == .month {
                monthPickerView
            } else if selectedFilterType == .custom {
                customDatePickerView
            }
        }
    }

    private var monthPickerView: some View {
        VStack(spacing: 16) {
            Text("월 선택")
                .fontStyle(.label2)
                .foregroundStyle(.neutral65)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearValues, id: \.self) { year in
                        Text("\(String(year))년")
                            .fontStyle(.headline1)
                            .foregroundStyle(.neutral65)
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()

                // Month Picker
                Picker("Month", selection: $selectedMonth) {
                    ForEach(monthValues, id: \.self) { month in
                        Text("\(month)월")
                            .fontStyle(.headline1)
                            .foregroundStyle(.neutral65)
                            .tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()
            }
            .onChange(of: selectedYear) { _, _ in
                updateDatesForSelectedMonth()
            }
            .onChange(of: selectedMonth) { _, _ in
                updateDatesForSelectedMonth()
            }
        }
    }

    private var yearValues: [Int] {
        Array(stride(from: 2030, through: 2020, by: -1))
    }

    private var monthValues: [Int] {
        Array(stride(from: 12, through: 1, by: -1))
    }

    private func updateDatesForSelectedMonth() {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1

        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.dateInterval(of: .month, for: startOfMonth)?.end else {
            return
        }

        tempStartDate = startOfMonth
        tempEndDate = calendar.date(byAdding: .second, value: -1, to: endOfMonth) ?? endOfMonth
    }

    private var customDatePickerView: some View {
        VStack(spacing: 4) {
            HStack(spacing: 16) {
                customDateField(.start)
                customDateField(.end)
            }

            bottomPickerSection
        }
    }

    @ViewBuilder
    private func customDateField(_ type: DatePickerType) -> some View {
        let isFieldFocused = type == .start ? isStartDateFocused : isEndDateFocused
        let date = type == .start ? tempStartDate : tempEndDate
        let label = type == .start ? "시작 날짜" : "종료 날짜"

        Button(action: {
            isStartDateFocused = type == .start
            isEndDateFocused = type == .end
            datePickerType = type
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .fontStyle(.label2)
                    .foregroundStyle(.neutral65)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(date.toyyyyMMddString())
                    .fontStyle(.headline2)
                    .foregroundStyle(.neutral65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 16)
            .frame(height: 56)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFieldFocused ? .opacityWhite35 : .opacityWhite85, lineWidth: isFieldFocused ? 1.5 : 1)
                    .background(.opacityWhite95)
            )
        }
        .contentTransition(.numericText())
    }

    @ViewBuilder
    private var bottomPickerSection: some View {
        if isStartDateFocused || isEndDateFocused {
            VStack(spacing: 0) {
                if isStartDateFocused {
                    DatePicker(
                        "",
                        selection: $tempStartDate,
                        displayedComponents: .date
                    )
                    .onTapGesture(count: 99){}
                    .tint(.neutral65)
                    .colorScheme(.dark)
                    .datePickerStyle(.wheel)
                    .frame(width: 320, height: 200)
                }

                if isEndDateFocused {
                    DatePicker(
                        "",
                        selection: $tempEndDate,
                        in: tempStartDate...,
                        displayedComponents: .date
                    )
                    .onTapGesture(count: 99){}
                    .tint(.neutral65)
                    .colorScheme(.dark)
                    .datePickerStyle(.wheel)
                    .frame(width: 320, height: 200)
                }
            }
        }
    }

    private func setupInitialDates() {
        let calendar = Calendar.current
        let now = Date()

        // Set default to current month
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now

        tempStartDate = startedDate ?? startOfMonth
        tempEndDate = endDate ?? calendar.date(byAdding: .second, value: -1, to: endOfMonth) ?? endOfMonth

        // Initialize month picker values
        let dateToUse = startedDate ?? now
        selectedYear = calendar.component(.year, from: dateToUse)
        selectedMonth = calendar.component(.month, from: dateToUse)
    }

    private func handleFilterTypeSelection(_ filterType: FilterType) {
        let calendar = Calendar.current
        let now = Date()

        switch filterType {
        case .month:
            showDatePicker = true
            isStartDateFocused = false
            isEndDateFocused = false
            // Set to current month by default
            selectedYear = calendar.component(.year, from: now)
            selectedMonth = calendar.component(.month, from: now)
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
            tempStartDate = startOfMonth
            tempEndDate = calendar.date(byAdding: .second, value: -1, to: endOfMonth) ?? endOfMonth

        case .threeMonth:
            showDatePicker = false
            isStartDateFocused = false
            isEndDateFocused = false
            // Set to last 3 months
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            tempStartDate = threeMonthsAgo
            tempEndDate = now

        case .custom:
            showDatePicker = true
            isStartDateFocused = true
            isEndDateFocused = false
            datePickerType = .start
            // Keep current dates or set defaults
            if tempStartDate > tempEndDate {
                tempStartDate = now
                tempEndDate = now
            }
        }
    }

    private func applyFilter() {
        startedDate = tempStartDate
        endDate = tempEndDate
        dismiss()
    }
}

#Preview {
    FilterBottomSheet(
        startedDate: .constant(nil),
        endDate: .constant(nil)
    )
}
