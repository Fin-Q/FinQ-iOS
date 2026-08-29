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

            case .study, .home, .myPage:
                break
            }

            return .none
        }
    }
}
