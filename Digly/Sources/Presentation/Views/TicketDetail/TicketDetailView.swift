import SwiftUI
import Photos

struct TicketDetailView: View {
    @StateObject var viewModel: TicketDetailViewModel = TicketDetailViewModel()
    @AppStorage(UserDefaultKeys.nickname) private var nicknameUD: String = ""
    
    let ticketId: Int
    let onNavigateToEdit: (Ticket) -> Void
    let onNavigateReset: () -> Void
    
    var body: some View {
        DGScreen(
            horizontalPadding: 0,
            backgroundColor: .common0,
            isLoading: viewModel.isLoading,
            onClick: {
                viewModel.isMenuPresent = false
            }
        ) {
            if let ticket = viewModel.ticket {
                ScrollView(.vertical, showsIndicators: false) {
                    headerSection
                    ticketName(ticket: ticket)
                        .padding(.bottom, 12)
                    ticketCard(ticket: ticket)
                        .padding(.bottom, 40)
                    basicInfoSection(ticket: ticket)

                    if let notes = ticket.notes, !notes.isEmpty {
                        notesSection(notes: notes)
                            .padding(.top, 40)
                    }

                    Spacer().frame(height: 120)
                }
            }
        }
        .alert(isPresented: $viewModel.isScreenshotTaken) {
            Alert(title: Text("스크린샷 저장 완료"), message: Text("스크린샷이 저장되었습니다."), dismissButton: .default(Text("확인")))
        }
        .sheet(isPresented: $viewModel.isEmotionSheetPresent) {
            if let ticket = viewModel.ticket {
                EmotionSelectionBottomSheet(
                    ticketId: ticket.id,
                    currentEmotions: ticket.emotions,
                    onEmotionsUpdated: { emotions in
                        viewModel.updateTicketEmotions(emotions)
                    }
                )
                .presentationDetents([.height(600)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(24)
                .presentationBackground(.clear)
            }
        }
        .overlay(alignment: .top) {
            if let ticket = viewModel.ticket, viewModel.isMenuPresent {
                menuSection(ticket)
            }
        }
        .animation(.mediumSpring, value: viewModel.isMenuPresent)
        
        .onAppear {
            viewModel.getTicketDetail(id: ticketId)
        }
        .onChange(of: viewModel.ticketDeleted) { deleted in
            if deleted {
                onNavigateReset()
            }
        }
    }
    
    private var headerSection: some View {
        TitleBackNavBar(title: "티켓 상세보기", isDarkMode: true) {
            HStack(spacing: 24) {
                Button(action: {
                    takeScreenshot(of: viewModel.ticket)
                }) {
                    Image("download")
                }
                
                Button(action: {
                    viewModel.isMenuPresent = true
                }) {
                    Image("detail")
                }
            }
        }
        .padding(.bottom, 32)
    }
    
    private func ticketName(ticket: Ticket) -> some View {
        Text(ticket.name)
            .fontStyle(.heading1)
            .foregroundStyle(.common100)
    }
    
    private func menuSection(_ ticket: Ticket) -> some View {
        ZStack (alignment: .top) {
            Color.black.opacity(0.1).ignoresSafeArea()
                .onTapGesture {
                    viewModel.isMenuPresent = false
                }
            
            VStack(alignment: .center, spacing: 0) {
                Button(action: {
                    onNavigateToEdit(ticket)
                    viewModel.isMenuPresent = false
                }) {
                    Text("수정하기")
                        .font(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .frame(height: 52)
                }
                
                Divider()
                    .background(Color.opacityWhite100)
                
                Button(action: {
                    viewModel.showDeleteConfirmation()
                    viewModel.isMenuPresent = false
                }) {
                    Text("삭제하기")
                        .font(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .frame(height: 52)
                }
            }
            .background(Color(hex: "222222"), in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 12)
            .padding(.top, 64)
        }
    }
    
    private func ticketCard(ticket: Ticket) -> some View {
        ZStack(alignment: .top) {
            Image("ticket-base-big")
            
            EmotionBackgroundGradient(selectedEmotions: ticket.emotions, size: 180, opacity: 0.26)
                .offset(y: -40)
                .animation(.spring(duration: 1.4), value: ticket.emotions)
            
            VStack(alignment: .center, spacing: 0) {
                Text("@\(nicknameUD.isEmpty ? "username" : nicknameUD)")
                    .fontStyle(.body2)
                    .foregroundStyle(.opacityWhite300)
                    .padding(.top, 24)

                Spacer()
                
                if ticket.emotions.isEmpty {
                    Text("관람 중에 느낀\n나만의 감정을 남겨볼까요?")
                        .fontStyle(.label2)
                        .foregroundStyle(.opacityWhite700)
                        .multilineTextAlignment(.center)
                    
                    Image("chevron_down_sm")
                        .padding(.top, -12)
                }
                
                Rectangle()
                    .fill(.opacityWhite100)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
                
                Group {
                    if !ticket.emotions.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(ticket.emotions.prefix(2), id: \.self) { emotion in
                                Text("#\(emotion.rawValue)")
                                    .fontStyle(.body1)
                                    .foregroundStyle(emotion.color)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                            }
                        }
                    } else {
                        Text("감정 남기러 가기")
                            .fontStyle(.headline2)
                            .foregroundStyle(.opacityWhite850)
                            .onTapGesture {
                                viewModel.isEmotionSheetPresent = true
                            }
                    }
                }
                .frame(height: 76, alignment: .center)
            }
            .padding(24)
        }
        .frame(width: 279, height: 376)
        .padding(.horizontal, 48)
    }

    
    private func basicInfoSection(ticket: Ticket) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기본정보")
                .fontStyle(.body1)
                .foregroundStyle(.opacityWhite800)
                .padding(.leading, 12)

            VStack(spacing: 16) {
                infoRow(title: "관람일", content: ticket.time.toKoreanDateString(), subtitle: "#\(ticket.count)번째 관람")

                infoRow(title: "장소", content: ticket.place)

                if let seatNumber = ticket.seatNumber {
                    infoRow(title: "좌석", content: seatNumber)
                }

                if let price = ticket.price {
                    infoRow(title: "가격", content: "\(price.formatted())원")
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 10,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: 24,
                    topTrailingRadius: 24
                )
                .stroke(.opacityWhite100, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }

    private func notesSection(notes: [Note]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Text("작성한 노트")
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite800)

                Text(" \(notes.count)")
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite800)

                Spacer()
            }
            .padding(.leading, 18)

            VStack(spacing: 16) {
                ForEach(notes) { note in
                    DGNoteCard(note: note)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    
    
    private func infoRow(title: String, content: String, subtitle: String? = nil) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title)
                .fontStyle(.body2)
                .foregroundStyle(.opacityWhite500)
                .frame(width: 66, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                Text(content)
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .fontStyle(.body2)
                        .foregroundStyle(.common100)
                }
            }

            Spacer()
        }
    }
    
    @MainActor
    func takeScreenshot(of ticket: Ticket?) {
        guard let ticket else { return }

        Task {
            do {
                let image = try await generateTicketImage(ticket: ticket)
                await saveImageToPhotos(image)
            } catch {
                print("Screenshot failed: \(error)")
                ToastManager.shared.show(.errorStringWithTask("스크린샷 저장"))
            }
        }
    }

    @MainActor
    private func generateTicketImage(ticket: Ticket) async throws -> UIImage {
        let ticketView = ticketCard(ticket: ticket)
        let controller = UIHostingController(rootView: ticketView)

        // Set fixed size for consistent rendering
        let targetSize = CGSize(width: 279, height: 376)
        controller.view.frame = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .clear

        // Get the current window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            throw ScreenshotError.noWindow
        }

        // Add to window temporarily for proper rendering
        window.addSubview(controller.view)
        controller.view.layoutIfNeeded()

        // Create image renderer
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { context in
            controller.view.layer.render(in: context.cgContext)
        }

        // Clean up
        controller.view.removeFromSuperview()

        return image
    }

    private func saveImageToPhotos(_ image: UIImage) async {
        // Check photo library authorization
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
        case .authorized, .limited:
            await performSave(image)
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            if newStatus == .authorized || newStatus == .limited {
                await performSave(image)
            } else {
                await MainActor.run {
                    ToastManager.shared.show(.errorWithMessage("사진 라이브러리 접근 권한이 필요합니다"))
                }
            }
        case .denied, .restricted:
            await MainActor.run {
                ToastManager.shared.show(.errorWithMessage("사진 라이브러리 접근 권한이 필요합니다"))
            }
        @unknown default:
            await MainActor.run {
                ToastManager.shared.show(.errorStringWithTask("스크린샷 저장"))
        }
    }
}
    private func performSave(_ image: UIImage) async {
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }

            await MainActor.run {
                viewModel.isScreenshotTaken = true
            }
        } catch {
            await MainActor.run {
                ToastManager.shared.show(.errorStringWithTask("스크린샷 저장"))
            }
        }
    }

    enum ScreenshotError: Error {
        case noWindow
        case permissionDenied
        case saveFailed
    }
}

#Preview {
    TicketDetailView(ticketId: 23, onNavigateToEdit: {}, onNavigateReset: {})
}
