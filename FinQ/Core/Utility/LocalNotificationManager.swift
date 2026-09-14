import UserNotifications

final class LocalNotificationManager: @unchecked Sendable {
    static let shared = LocalNotificationManager()
    static let dailyNotificationID = "finq.daily.10am"

    private init() {}

    func scheduleDailyNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "오늘의 금융 질문, 궁금하지 않나요?"
        content.body = "3분이면 하나씩 알아갈 수 있어요."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: Self.dailyNotificationID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [Self.dailyNotificationID]
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            AppLogger.shared.log("로컬 알림 등록 실패: \(error)", level: .error)
        }
    }

    func cancelDailyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [Self.dailyNotificationID]
        )
    }
}
