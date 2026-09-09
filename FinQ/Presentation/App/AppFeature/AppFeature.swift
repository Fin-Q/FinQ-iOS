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
        case authViewDidDisappear
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
            case .auth(.delegate(.loginSucceeded)):
                state.route = .tabBar
                state.tabBar = TabBarFeature.State()
                return .none
                
            case .auth(.delegate(.startOnboarding)):
                state.onboarding = OnboardingFeature.State()
                state.route = .onboarding
                return .none

            case .onboarding(.delegate(.completed)):
                state.route = .tabBar
                state.onboarding = OnboardingFeature.State()
                state.tabBar = TabBarFeature.State()
                return .none
                
            case .tabBar(.delegate(.logout)):
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.onboarding = OnboardingFeature.State()
                state.tabBar = TabBarFeature.State()
                return .none
                
            case .auth, .onboarding, .tabBar:
                return .none
                
            case .authViewDidDisappear:
                guard state.route == .onboarding else { return .none }
                
                state.auth = AuthMainFeature.State()
                return .none
            }
        }
    }
}
