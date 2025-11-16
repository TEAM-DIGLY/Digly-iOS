import SwiftUI

struct InquiryView: View {
    @EnvironmentObject private var router: HomeRouter

    @StateObject private var viewModel = InquiryViewModel()
    @FocusState private var focusedField: InquiryFieldType?

    var body: some View {
        DGScreen(horizontalPadding: 0, onClick: {
            focusedField = nil
        }) {
            navigationBar
                .padding(.horizontal, 16)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    emailSection
                        .padding(.bottom, 12)
                    requiredLabel("문의내용")
                    titleField
                    contentEditor
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
    }

    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: {
                PopupManager.shared.show(.backWarning(value: "문의 작성") {
                    router.pop()
                })
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
                viewModel.submitInquiry {
                    router.pop()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .neutral900))
                        .scaleEffect(0.8)
                } else {
                    Text("등록")
                        .fontStyle(.headline2)
                        .foregroundStyle(viewModel.canSubmit ? .neutral900 : Color.neutral900.opacity(0.4))
                }
            }
            .padding(.horizontal, 8)
            .disabled(!viewModel.canSubmit)
        }
        .padding(.vertical, 12)
    }

    // MARK: - Email Section
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            requiredLabel("답변받을 이메일")

            DGTextField(
                text: $viewModel.email,
                placeholder: "yourmail@mail.com",
                keyboardType: .emailAddress,
                backgroundColor: .neutral50,
                borderColor: .clear,
                isDeleteButtonPresent: focusedField == .email
            ) {
                focusedField = .title
            }
            .focused($focusedField, equals: .email)
            .onAppear {
                focusedField = .email
            }
        }
    }

    // MARK: - Title Field
    private var titleField: some View {
        DGTextField(
            text: $viewModel.title,
            placeholder: "제목 (최대 30자)",
            backgroundColor: .neutral50,
            borderColor: .clear,
            isDeleteButtonPresent: focusedField == .title
        ) {
            focusedField = .content
        }
        .focused($focusedField, equals: .title)
        .textInputLimit(text: $viewModel.title, maxLength: viewModel.titleMaxLength)
    }

    // MARK: - Content Editor
    private var contentEditor: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topLeading) {
                if viewModel.content.isEmpty {
                    Text("내용을 입력하세요")
                        .fontStyle(.body1)
                        .foregroundStyle(.neutral300)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }

                TextEditor(text: $viewModel.content)
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
                Text("\(viewModel.content.count)/\(viewModel.contentMaxLength)")
                    .fontStyle(.caption2)
                    .foregroundStyle(.neutral500)
            }
            .padding(.horizontal, 12)
        }
        .textInputLimit(text: $viewModel.content, maxLength: viewModel.contentMaxLength)
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
}

#Preview {
    InquiryView()
}
