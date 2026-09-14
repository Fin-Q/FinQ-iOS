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
        var calendar: StreakCalendar?
        var status: StreakStatus?
        var today: Date = Date()
        var isLoading: Bool = false
        var errorMessage: String?

        var isTodayCompleted: Bool {
            let components = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: today)
            guard let year = components.year, let month = components.month, let day = components.day else { return false }
            return calendar?.streakDates.contains(String(format: "%04d-%02d-%02d", year, month, day)) == true
        }
    }

    enum Action {
        case onAppear
        case fetchSucceeded(StreakCalendar, StreakStatus)
        case fetchFailed(String)
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

                return .run { send in
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
                }

            case let .fetchSucceeded(calendar, status):
                state.calendar = calendar
                state.status = status
                state.isLoading = false
                state.today = now
                return .none

            case let .fetchFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
