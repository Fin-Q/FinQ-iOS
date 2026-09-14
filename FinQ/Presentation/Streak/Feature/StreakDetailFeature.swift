import Foundation
import ComposableArchitecture

@Reducer
struct StreakDetailFeature {

    @ObservableState
    struct State: Equatable {
        var streakDays: Int = 0
        var daysUntilNextBonus: Int = 7
        var todayStudyMinutes: Int = 0
        var year: Int
        var month: Int
        var attendedDays: Set<Int>
        var todayDay: Int
        var isLoading: Bool = false

        init() {
            let now = Date()
            let cal = Calendar.current
            self.year = cal.component(.year, from: now)
            self.month = cal.component(.month, from: now)
            self.todayDay = cal.component(.day, from: now)
            self.attendedDays = []
        }
    }

    enum Action {
        case onAppear
        case streakStatusResponse(Result<StreakStatus, Error>)
        case calendarResponse(Result<StreakCalendar, Error>)
    }

    @Dependency(\.streakUseCase) var streakUseCase

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let monthString = String(format: "%d-%02d", state.year, state.month)
                return .run { [month = monthString] send in
                    async let statusResult = Result { try await streakUseCase.fetchStreakStatus() }
                    async let calendarResult = Result { try await streakUseCase.fetchStreakCalendar(month: month) }
                    await send(.streakStatusResponse(await statusResult))
                    await send(.calendarResponse(await calendarResult))
                }

            case .streakStatusResponse(.success(let status)):
                state.isLoading = false
                state.streakDays = status.currentStreak
                state.daysUntilNextBonus = status.daysUntilNextBonus
                return .none

            case .streakStatusResponse(.failure):
                state.isLoading = false
                return .none

            case .calendarResponse(.success(let calendar)):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let cal = Calendar.current
                var days = Set<Int>()
                for dateString in calendar.streakDates {
                    guard let date = formatter.date(from: dateString) else { continue }
                    let y = cal.component(.year, from: date)
                    let m = cal.component(.month, from: date)
                    if y == state.year && m == state.month {
                        days.insert(cal.component(.day, from: date))
                    }
                }
                state.attendedDays = days
                return .none

            case .calendarResponse(.failure):
                return .none
            }
        }
    }
}
