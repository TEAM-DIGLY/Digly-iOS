import SwiftUI

/// - note:  라벨이 추가된 TextField입니다.
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
