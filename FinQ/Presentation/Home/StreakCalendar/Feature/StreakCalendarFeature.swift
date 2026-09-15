//
//  StreakCalendarFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StreakCalendarFeature {
    @Dependency(\.streakUseCase) private var streakUseCase
    @Dependency(\.date.now) private var now

    @ObservableState
    struct State: Equatable {
        var profileImageURL: String?
        var calendar: StreakCalendar?
        var status: StreakStatus?
        var today: Date = Date()
        var isTodayCompleted: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case onAppear
        case fetchProfileImageSucceeded(String)
        case fetchSucceeded(StreakCalendar, StreakStatus)
        case fetchCalendarSucceeded(StreakCalendar)
        case fetchCalendarIgnored(String)
        case fetchFailed(String)
        case previousMonthRequested
        case nextMonthRequested
        case alertOKButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                state.today = now

                return .merge(
                    .run { send in
                        do {
                            async let calendar = streakUseCase.fetchCalendar(month: nil)
                            async let status = streakUseCase.fetchStatus()
                            let result = try await (calendar, status)
                            guard !Task.isCancelled else { return }
                            await send(.fetchSucceeded(result.0, result.1))
                        } catch {
                            guard !Task.isCancelled else { return }
                            await send(.fetchFailed(error.localizedDescription))
                        }
                    },
                    .run { send in
                        do {
                            let imageURL = try await streakUseCase.fetchProfileImageURL()
                            guard !Task.isCancelled else { return }
                            await send(.fetchProfileImageSucceeded(imageURL))
                        } catch {
                            AppLogger.shared.log("프로필 이미지 조회 실패: \(error.localizedDescription)", level: .error)
                        }
                    }
                )

            case let .fetchProfileImageSucceeded(imageURL):
                state.profileImageURL = imageURL
                return .none

            case let .fetchSucceeded(calendar, status):
                state.calendar = calendar
                state.status = status
                state.isLoading = false
                state.today = now
                state.isTodayCompleted = isCompleted(date: state.today, in: calendar)
                return .none

            case let .fetchCalendarSucceeded(calendar):
                state.calendar = calendar
                state.isLoading = false
                return .none

            case let .fetchCalendarIgnored(month):
                state.calendar = StreakCalendar(month: month, streakDates: [])
                state.isLoading = false
                return .none

            case let .fetchFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .previousMonthRequested:
                return fetchCalendar(monthOffset: -1, state: &state)

            case .nextMonthRequested:
                return fetchCalendar(monthOffset: 1, state: &state)

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none
            }
        }
    }

    private func fetchCalendar(monthOffset: Int, state: inout State) -> Effect<Action> {
        guard !state.isLoading, let currentMonth = state.calendar?.month, let targetMonth = month(offsetBy: monthOffset, from: currentMonth) else { return .none }
        state.isLoading = true
        state.errorMessage = nil

        return .run { send in
            do {
                let calendar = try await streakUseCase.fetchCalendar(month: targetMonth)
                guard !Task.isCancelled else { return }
                await send(.fetchCalendarSucceeded(calendar))
            } catch let error as APIErrorResponse where error.errorCode == "STREAK_MONTH_OUT_OF_RANGE" {
                guard !Task.isCancelled else { return }
                await send(.fetchCalendarIgnored(targetMonth))
            } catch {
                guard !Task.isCancelled else { return }
                await send(.fetchFailed(error.localizedDescription))
            }
        }
    }

    private func month(offsetBy offset: Int, from month: String) -> String? {
        let values = month.split(separator: "-").compactMap { Int($0) }
        let calendar = Calendar(identifier: .gregorian)
        guard values.count == 2, let date = calendar.date(from: DateComponents(year: values[0], month: values[1], day: 1)), let targetDate = calendar.date(byAdding: .month, value: offset, to: date) else { return nil }
        let components = calendar.dateComponents([.year, .month], from: targetDate)
        guard let year = components.year, let month = components.month else { return nil }
        return String(format: "%04d-%02d", year, month)
    }

    private func isCompleted(date: Date, in calendar: StreakCalendar) -> Bool {
        let components = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else { return false }
        return calendar.streakDates.contains(String(format: "%04d-%02d-%02d", year, month, day))
    }
}
