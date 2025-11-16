import SwiftUI

struct InquiryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var focusedField: InquiryFieldType?

    enum InquiryFieldType {
        case email
        case title
        case content
    }
    
    private let titleMaxLength = 30
    private let contentMaxLength = 1000

    private var canSubmit: Bool {
        !email.isEmpty && !title.isEmpty && !content.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            navigationBar

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Email Section
                    emailSection

                    // Inquiry Content Section
                    inquiryContentSection
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            focusedField = nil
        }
    }

    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("chevron_left")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral900)
            }

            Spacer()

            Text("1:1 문의")
                .fontStyle(.headline2)
                .foregroundStyle(.neutral900)

            Spacer()

            Button(action: {
                // Submit inquiry
                submitInquiry()
            }) {
                Text("등록")
                    .fontStyle(.headline2)
                    .foregroundStyle(canSubmit ? .neutral900 : Color.neutral900.opacity(0.4))
            }
            .disabled(!canSubmit)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }

    // MARK: - Email Section
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            requiredLabel("답변받을 이메일")

            DGTextField(
                text: $email,
                placeholder: "yourmail@mail.com",
                keyboardType: .emailAddress,
                backgroundColor: .neutral50,
                borderColor: .clear,
                isDeleteButtonPresent: focusedField == .email
            )
            .focused($focusedField, equals: .email)
        }
    }

    // MARK: - Inquiry Content Section
    private var inquiryContentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            requiredLabel("문의내용")

            VStack(spacing: 12) {
                // Title Field
                titleField

                // Content Editor
                contentEditor
            }
        }
    }

    // MARK: - Title Field
    private var titleField: some View {
        DGTextField(
            text: $title,
            placeholder: "제목 (최대 30자)",
            backgroundColor: .neutral50,
            borderColor: .clear,
            isDeleteButtonPresent: focusedField == .title
        )
        .focused($focusedField, equals: .title)
        .textInputLimit(text: $title, maxLength: titleMaxLength)
    }

    // MARK: - Content Editor
    private var contentEditor: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topLeading) {
                if content.isEmpty {
                    Text("내용을 입력하세요")
                        .fontStyle(.body1)
                        .foregroundStyle(.neutral300)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }

                TextEditor(text: $content)
                    .fontStyle(.body1)
                    .foregroundStyle(.text0)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 200)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: .content)
            }
            .background(.neutral50)
            .cornerRadius(14)

            HStack {
                Spacer()
                Text("\(content.count)/\(contentMaxLength)")
                    .fontStyle(.caption2)
                    .foregroundStyle(.neutral500)
            }
            .padding(.horizontal, 12)
        }
        .textInputLimit(text: $content, maxLength: contentMaxLength)
    }

    // MARK: - Helper Views
    private func requiredLabel(_ text: String) -> some View {
        HStack(spacing: 0) {
            Text(text)
                .fontStyle(.label2)
                .foregroundStyle(.neutral600)

            Text(" *")
                .fontStyle(.label2)
                .foregroundStyle(.error)
        }
        .padding(.horizontal, 12)
    }

    // MARK: - Actions
    private func submitInquiry() {
        // TODO: Implement inquiry submission
        dismiss()
    }
}


#Preview {
    InquiryView()
} 
