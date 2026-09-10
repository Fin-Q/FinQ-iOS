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
    enum Route: Equatable {
        case auth
        case onboarding
        case tabBar
    }
    
    @ObservableState
    struct State: Equatable {
        var route: Route = .auth
        var auth = AuthMainFeature.State()
        var onboarding = OnboardingFeature.State()
        var tabBar = TabBarFeature.State()
    }
    
    enum Action {
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
            case let .auth(.delegate(.loginSucceeded(isOnboardingCompleted))):
                guard state.route == .auth else { return .none }

                if isOnboardingCompleted {
                    state.tabBar = TabBarFeature.State(selectedTab: .home)
                    state.route = .tabBar
                } else {
                    state.onboarding = OnboardingFeature.State()
                    state.route = .onboarding
                }
                return .none
                
            case .onboarding(.delegate(.completed)):
                guard state.route == .onboarding else { return .none }

                state.tabBar = TabBarFeature.State(selectedTab: .home)
                state.route = .tabBar
                return .none
                
            case .tabBar(.delegate(.logout)), .tokenRefreshFailed:
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                state.tabBar = TabBarFeature.State()
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
}
