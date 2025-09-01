import SwiftUI

struct TextFieldWithMenu: View {
    @Binding var selectedValue: String
    @State private var isExpanded: Bool = false
    @State private var searchText: String = ""
    
    let placeholder: String
    let searchResults: [String]
    let onSelectionChanged: ((String) -> Void)?
    
    init(
        selectedValue: Binding<String>,
        placeholder: String,
        searchResults: [String],
        onSelectionChanged: ((String) -> Void)? = nil
    ) {
        self._selectedValue = selectedValue
        self.placeholder = placeholder
        self.searchResults = searchResults
        self.onSelectionChanged = onSelectionChanged
        self._searchText = State(initialValue: selectedValue.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DGTextField(
                text: $searchText,
                placeholder: "극 제목 입력",
                placeholderColor: .opacityWhite65,
                backgroundColor: .opacityWhite95,
                borderColor: .clear
            )
            .onChange(of: searchText) { _, newValue in
                selectedValue = newValue
            }
            
            if !searchText.isEmpty && !searchResults.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(searchResults, id: \.self) { searchResult in
                            Button(action: {
                                isExpanded = false
                                selectedValue = searchResult
                                searchText = searchResult
                                onSelectionChanged?(searchResult)
                            }) {
                                Text(searchResult)
                                    .fontStyle(.body2)
                                    .foregroundStyle(.opacityWhite5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 44)
                            }
                            
                            if searchResult != searchResults.last {
                                Divider()
                                    .background(.opacityWhite65)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .background(.opacityWhite95)
                .frame(maxHeight: 200)
            }
        }
        // 외곽 오버레이는 제거하여 컨테이너가 부모의 제안 크기로 과도 확장되는 문제를 방지
    }
}
