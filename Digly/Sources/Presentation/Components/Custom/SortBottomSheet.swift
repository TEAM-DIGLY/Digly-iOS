import SwiftUI

struct SortBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var startedDate: Date?
    @Binding var endDate: Date?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("취소") {
                    dismiss()
                }
                .foregroundStyle(.neutral45)
                
                Spacer()
                
                Text("정렬")
                    .fontStyle(.headline1)
                    .foregroundStyle(.neutral5)
                
                Spacer()
                
                Button("완료") {
                    dismiss()
                }
                .foregroundStyle(.primary)
                .fontWeight(.medium)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            
            Divider()
                .background(.neutral85)
            
            // Sort options
            VStack(spacing: 4) {
//                ForEach(sortTypes, id: \.self) { sortType in
//                    sortOptionRow(sortType)
//                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .background(.common100)
        .presentationDetents([.height(400)])
    }
    
//    private func sortOptionRow(_ sortType: SortType) -> some View {
//        Button(action: {
//            onSortTypeSelected(sortType)
//            dismiss()
//        }) {
//            HStack(spacing: 0) {
//                Image(systemName: selectedSortType == sortType ? "checkmark.circle.fill" : "circle")
//                    .foregroundStyle(selectedSortType == sortType ? .neutral5 : .neutral45)
//                    .frame(width: 24, height: 24)
//                
//                Text(sortType.displayName)
//                    .fontStyle(.body1)
//                    .foregroundStyle(.neutral5)
//                    .padding(.leading, 12)
//                
//                Spacer()
//            }
//            .padding(.vertical, 12)
//            .padding(.horizontal, 24)
//        }
//    }
}
