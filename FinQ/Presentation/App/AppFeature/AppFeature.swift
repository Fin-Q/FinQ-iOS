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
    
    enum LaunchDestination: Equatable, Sendable {
        case auth
        case authenticated(OnboardingStatus)
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
        case launchDestinationResolved(LaunchDestination)
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
                    let destination: LaunchDestination
                    
                    if hasActiveSession {
                        do {
                            let onboardingStatus = try await onboardingUseCase.getOnboardingStatus()
                            destination = .authenticated(onboardingStatus)
                        } catch {
                            AppLogger.shared.log("온보딩 상태 조회 실패: \(error.localizedDescription)", level: .error)
                            destination = .auth
                        }
                    } else {
                        destination = .auth
                    }
                    
                    try await minimumDisplay
                    await send(.launchDestinationResolved(destination))
                }

            case let .launchDestinationResolved(destination):
                guard state.route == .launching else { return .none }

                switch destination {
                case .auth:
                    state.isWaitingForInitialHome = false
                    state.route = .auth
                    return .none
                    
                case let .authenticated(onboardingStatus):
                    self.routeByOnboardingStatus(onboardingStatus, state: &state, shouldWaitForInitialHome: true)
                    return onboardingStatus == .completed ? self.registerPushToken() : .none
                }
                
            case .auth(.delegate(.guestModeStarted)):
                loginUseCase.clearSession()
                state.isWaitingForInitialHome = false
                state.tabBar = TabBarFeature.State(selectedTab: .home, isGuestMode: true)
                state.route = .tabBar
                return .none

            case let .auth(.delegate(.loginSucceeded(onboardingStatus))):
                guard state.route == .auth else { return .none }
                
                self.routeByOnboardingStatus(onboardingStatus, state: &state, shouldWaitForInitialHome: false)
                return self.registerPushToken()
                
            case .onboarding(.delegate(.completed)):
                guard state.route == .onboarding else { return .none }

                state.isWaitingForInitialHome = false
                state.tabBar = TabBarFeature.State(selectedTab: .home)
                state.route = .tabBar
                return .none

            case .tabBar(.delegate(.loginRequested)):
                guard state.route == .tabBar else { return .none }

                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                return .none
                
            case .tabBar(.delegate(.logout)):
                loginUseCase.clearSession()
                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                return .none

            case .tabBar(.delegate(.withdrawalCompleted)):
                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                return .none

            case .tokenRefreshFailed:
                state.isWaitingForInitialHome = false
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
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
                if route != .tabBar { state.tabBar = TabBarFeature.State() }
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
    
    private func routeByOnboardingStatus(_ onboardingStatus: OnboardingStatus, state: inout State, shouldWaitForInitialHome: Bool) {
        state.isWaitingForInitialHome = false
        
        switch onboardingStatus {
        case .interestSelection:
            state.onboarding = OnboardingFeature.State()
            state.route = .onboarding
            
        case .characterGuide:
            var onboardingState = OnboardingFeature.State()
            onboardingState.path.append(.characterGuide(CharacterGuideFeature.State()))
            state.onboarding = onboardingState
            state.route = .onboarding
            
        case .completed:
            state.tabBar = TabBarFeature.State(selectedTab: .home)
            state.isWaitingForInitialHome = shouldWaitForInitialHome
            state.route = .tabBar
        }
    }
}
