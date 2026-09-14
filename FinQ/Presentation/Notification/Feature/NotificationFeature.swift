import Foundation
import ComposableArchitecture

struct NotificationItem: Equatable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let timeAgo: String
}

@Reducer
struct NotificationFeature {

    @ObservableState
    struct State: Equatable {
        var notifications: [NotificationItem] = [
            NotificationItem(id: UUID(), title: "출석 인증 안내!", description: "문제까지 풀어야 출석 인증이 완료될 수 있어요!\n5초만에 문제를 풀고, XP를 얻어보세요!", timeAgo: "1시간 전"),
            NotificationItem(id: UUID(), title: "출석 인증 안내!", description: "문제까지 풀어야 출석 인증이 완료될 수 있어요!\n5초만에 문제를 풀고, XP를 얻어보세요!", timeAgo: "1시간 전"),
            NotificationItem(id: UUID(), title: "출석 인증 안내!", description: "문제까지 풀어야 출석 인증이 완료될 수 있어요!\n5초만에 문제를 풀고, XP를 얻어보세요!", timeAgo: "1시간 전"),
            NotificationItem(id: UUID(), title: "출석 인증 안내!", description: "문제까지 풀어야 출석 인증이 완료될 수 있어요!\n5초만에 문제를 풀고, XP를 얻어보세요!", timeAgo: "1시간 전"),
        ]
    }

    enum Action {}

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
