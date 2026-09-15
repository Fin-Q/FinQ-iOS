//
//  AppFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.loginUseCase) private var loginUseCase
    @Dependency(\.onboardingUseCase) private var onboardingUseCase
    @Dependency(\.pushTokenUseCase) private var pushTokenUseCase

    enum Route: Equatable {
        case launching
        case auth
        case onboarding
        case tabBar
    }
    
    @ObservableState
    struct State: Equatable {
        var route: Route = .launching
        var isWaitingForInitialHome: Bool = false
        var auth = AuthMainFeature.State()
        var onboarding = OnboardingFeature.State()
        var tabBar = TabBarFeature.State()
    }
    
    enum Action {
        case onAppear
        case splashRoutingResolved(Route)
        case auth(AuthMainFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case tabBar(TabBarFeature.Action)
        case tokenRefreshFailed
        case routeTransitionCompleted(Route)
    }
    
    var body: some ReducerOf<Self> {
        Scope(\.auth, action: \.auth) {
            AuthMainFeature()
        }

        Scope(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        
        Scope(\.tabBar, action: \.tabBar) {
            TabBarFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.route == .launching else { return .none }

                let hasActiveSession = loginUseCase.hasActiveSession()
                return .run { send in
                    async let minimumDisplay: Void = clock.sleep(for: .seconds(2))
                    let route: Route

                    if hasActiveSession {
                        do {
                            let isCompleted = try await onboardingUseCase.isOnboardingCompleted()
                            route = isCompleted ? .tabBar : .onboarding
                        } catch {
                            AppLogger.shared.log("온보딩 상태 조회 실패: \(error.localizedDescription)", level: .error)
                            route = .auth
                        }
                    } else {
                        route = .auth
                    }

                    try await minimumDisplay
                    await send(.splashRoutingResolved(route))
                }

            case let .splashRoutingResolved(route):
                guard state.route == .launching else { return .none }

                switch route {
                case .tabBar:
                    state.tabBar = TabBarFeature.State(selectedTab: .home)
                    state.isWaitingForInitialHome = true
                    state.route = .tabBar
                    return registerPushToken()

                case .onboarding:
                    state.isWaitingForInitialHome = false
                    state.onboarding = OnboardingFeature.State()
                    state.route = .onboarding
                    return .none

                case .auth, .launching:
                    state.isWaitingForInitialHome = false
                    state.route = .auth
                    return .none
                }

            case let .auth(.delegate(.loginSucceeded(isOnboardingCompleted))):
                guard state.route == .auth else { return .none }

                state.isWaitingForInitialHome = false
                if isOnboardingCompleted {
                    state.tabBar = TabBarFeature.State(selectedTab: .home)
                    state.route = .tabBar
                } else {
                    state.onboarding = OnboardingFeature.State()
                    state.route = .onboarding
                }
                return registerPushToken()
                
            case .onboarding(.delegate(.completed)):
                guard state.route == .onboarding else { return .none }

                state.isWaitingForInitialHome = false
                state.tabBar = TabBarFeature.State(selectedTab: .home)
                state.route = .tabBar
                return .none
                
            case .tabBar(.delegate(.logout)):
                loginUseCase.clearSession()
                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                state.tabBar = TabBarFeature.State()
                return .none

            case .tokenRefreshFailed:
                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                state.tabBar = TabBarFeature.State()
                return .none
                
            case .tabBar(.home(.fetchHomeSucceeded)), .tabBar(.home(.fetchHomeFailed)):
                state.isWaitingForInitialHome = false
                return .none

            case .auth, .onboarding, .tabBar:
                return .none
                
            case let .routeTransitionCompleted(route):
                guard state.route == route else { return .none }

                // 페이드가 끝나기 전에는 사라지는 화면의 스택을 유지합니다.
                if route != .auth { state.auth = AuthMainFeature.State() }
                if route != .onboarding { state.onboarding = OnboardingFeature.State() }
                return .none
            }
        }
    }

    private func registerPushToken() -> Effect<Action> {
        return .run { _ in
            do {
                try await pushTokenUseCase.registerCurrentToken()
            } catch {
                AppLogger.shared.log("FCM 토큰 등록 실패: \(error.localizedDescription)", level: .error)
            }
        }
    }
}
