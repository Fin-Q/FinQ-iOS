//
//  TabBarFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import ComposableArchitecture

@Reducer
struct TabBarFeature {
    enum Tab: Hashable {
        case study
        case home
        case myPage
    }

    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .study

        var study = StudyFeature.State()
        var home = HomeFeature.State()
        var myPage = MyPageFeature.State()
    }

    enum Action {
        case selectedTabChanged(Tab)

        case study(StudyFeature.Action)
        case home(HomeFeature.Action)
        case myPage(MyPageFeature.Action)
        
        case delegate(Delegate)
        enum Delegate {
            case logout
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.study, action: \.study) {
            StudyFeature()
        }

        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Scope(state: \.myPage, action: \.myPage) {
            MyPageFeature()
        }

        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none
                
            case .myPage(.delegate(.logoutSucceeded)):
                return .send(.delegate(.logout))

            case .study, .home, .myPage, .delegate:
                return .none
            }
        }
    }
}
