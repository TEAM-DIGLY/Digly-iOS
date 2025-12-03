import Foundation

@MainActor
class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    
    private var currentPage: Int = 0
    private let notificationRepository: NotificationRepository
    
    init(
        notificationRepository: NotificationRepository = NotificationRepository()
    ) {
        self.notificationRepository = notificationRepository
        Task { await refresh() }
    }
    
    func refresh() async {
        guard !isLoading else { return }
        currentPage = 0
        hasMorePages = true
        await fetchAlarms(page: 0, isRefresh: true)
    }
    
    func loadNextPage() {
        guard hasMorePages && !isLoadingMore && !isLoading else { return }
        let nextPage = currentPage + 1
        
        Task { await fetchAlarms(page: nextPage, isRefresh: false) }
    }

    func deleteAlarm(_ alarmId: Int) {
        Task {
            do {
                try await notificationRepository.deleteNotification(id: alarmId)
                alarms.removeAll { $0.id == alarmId }
            } catch {
                ToastManager.shared.show(.errorStringWithTask("알림 삭제"))
            }
        }
    }
    
    private func fetchAlarms(page: Int, isRefresh: Bool) async {
        isLoading = isRefresh
        isLoadingMore = !isRefresh
        
        defer {
            isLoading = false
            isLoadingMore = false
        }
        
        do {
            let response = try await notificationRepository.getNotifications(page: page)
            
            if isRefresh {
                alarms = response.notifications
            } else {
                alarms.append(contentsOf: response.notifications)
            }
            
            hasMorePages = response.pageInfo.totalPages > page + 1
            currentPage = page
        } catch {
            ToastManager.shared.show(.errorStringWithTask("알림 조회"))
        }
    }
}
