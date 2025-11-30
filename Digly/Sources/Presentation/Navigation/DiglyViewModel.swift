import Foundation
import Combine

@MainActor
final class DiglyViewModel: ObservableObject {
    @Published private(set) var isInitializing = true
    @Published var selectedTab = 0

    private var cancellables = Set<AnyCancellable>()

    init(){
        setupNotifications()
        initialize()
    }

    private func setupNotifications() {
        NotificationCenter.default.publisher(for: NotificationEvent.didTapTicketBook.name)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let info = notification.userInfo as? [String: Any],
                      let tabIndex = info[NotificationEvent.didTapTicketBook.userInfo] as? Int else {
                    return
                }
                self?.selectedTab = tabIndex
            }
            .store(in: &cancellables)
    }

    private func initialize() {
        Task {
            guard let refreshToken = KeychainManager.shared.getRefreshToken(),
                  !refreshToken.isEmpty else {
                await MainActor.run {
                    AuthManager.shared.logout()
                    self.isInitializing = false
                }
                return
            }
            
            let refreshSuccess = await TokenManager.shared.ensureValidToken()
            
            await MainActor.run {
                if refreshSuccess {
                    AuthManager.shared.setLoggedIn(true)
                } else {
                    AuthManager.shared.logout()
                }
                
                self.isInitializing = false
            }
        }
    }
}
