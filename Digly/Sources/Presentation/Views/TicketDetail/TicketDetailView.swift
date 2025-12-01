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
                    TicketDetailContent(ticket: ticket) {
                        viewModel.isEmotionSheetPresent = true
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
                    currentEmotions: ticket.emotions,
                    updateEmotion: { emotions in
                        viewModel.updateTicketEmotions(emotions)
                        viewModel.isEmotionSheetPresent = false
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
        var tmpTicket = ticket
        tmpTicket.notes = nil
        
        let ticketView = AnyView(
            TicketDetailContent(ticket: tmpTicket, onTapAddEmotion: {}).frame(height: 750, alignment: .center).background(.bgDark)
        )
        
        let controller = UIHostingController(rootView: ticketView)
        
        // Set fixed size for consistent rendering
        let targetSize = CGSize(width: 327, height: 750)
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
        
        controller.view.removeFromSuperview()
        
        return image
    }
    
    private func saveImageToPhotos(_ image: UIImage) async {
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
    TicketDetailView(ticketId: 23, onNavigateToEdit: {_ in }, onNavigateReset: {})
}
