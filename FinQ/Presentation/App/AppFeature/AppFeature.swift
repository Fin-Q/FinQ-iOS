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
        case tabBar
    }
    
    @ObservableState
    struct State: Equatable {
        var route: Route = .auth
        var auth = AuthMainFeature.State()
        var tabBar = TabBarFeature.State()
    }
    
    enum Action {
        case auth(AuthMainFeature.Action)
        case tabBar(TabBarFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(\.auth, action: \.auth) {
            AuthMainFeature()
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
                
            case .tabBar(.delegate(.logout)):
                state.route = .auth
                state.auth = AuthMainFeature.State()
                state.tabBar = TabBarFeature.State()
                return .none
                
            case .auth, .tabBar:
                return .none
            }
        }
    }
}
