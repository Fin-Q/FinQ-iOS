//
//  HomeFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @Dependency(\.homeUseCase) private var homeUseCase
    @Dependency(\.myPageUseCase) private var myPageUseCase
    @Dependency(\.permissionManager) private var permissionManager
    private enum CancelID { case fetchHome }

    @Reducer
    enum Path {
        case streakCalendar(StreakCalendarFeature)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var home: HomeSummary?
        var isLoading: Bool = false
        var errorMessage: String?
        var isGuestMode: Bool = false
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case fetchHomeSucceeded(HomeSummary)
        case fetchHomeFailed(String)
        case calendarButtonTapped
        case guestLoginButtonTapped
        case questionTapped(HomeQuestion)
        case alertOKButtonTapped
        case path(StackActionOf<Path>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case loginRequested
            case questionTapped(HomeQuestion)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading, state.path.isEmpty else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                let isGuestMode = state.isGuestMode

                let fetchHomeEffect: Effect<Action> = .run { send in
                    do {
                        let home = try await homeUseCase.fetchHome(isGuestMode: isGuestMode)
                        guard !Task.isCancelled else { return }
                        await send(.fetchHomeSucceeded(home))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchHomeFailed(error.localizedDescription))
                    }
                }
                    .cancellable(id: CancelID.fetchHome, cancelInFlight: true)

                if isGuestMode {
                    return fetchHomeEffect
                }

                let notificationSyncEffect: Effect<Action> = .run { _ in
                    let status = await permissionManager.notificationPermissionStatus()
                    guard status == .denied else { return }

                    do {
                        try await myPageUseCase.updateNotificationSetting(isEnabled: false)
                    } catch {
                        AppLogger.shared.log("알림 설정 OFF 동기화 실패: \(error.localizedDescription)", level: .error)
                    }
                }

                return .merge(fetchHomeEffect, notificationSyncEffect)

            case .onDisappear:
                state.isLoading = false
                return .cancel(id: CancelID.fetchHome)

            case let .fetchHomeSucceeded(home):
                state.home = home
                state.isLoading = false
                return .none

            case let .fetchHomeFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .calendarButtonTapped:
                guard state.path.isEmpty else { return .none }
                state.path.append(.streakCalendar(StreakCalendarFeature.State()))
                return .none

            case .guestLoginButtonTapped:
                guard state.isGuestMode else { return .none }
                return .send(.delegate(.loginRequested))

            case let .questionTapped(question):
                return .merge(
                    .send(.delegate(.questionTapped(question))),
                    .run { _ in
                        await homeUseCase.logHomeQuestionTapped(contentID: question.contentID, categoryCode: question.categoryCode)
                    }
                )

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .path, .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension HomeFeature.Path.State: Equatable {}
