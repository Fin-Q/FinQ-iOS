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
        case home
        case knowledgeMap
        case myPage
    }

    @ObservableState
    struct State: Equatable {
        let isGuestMode: Bool
        var selectedTab: Tab = .home
        var isGuestMyPageAlertPresented: Bool = false

        var knowledgeMap: KnowledgeMapFeature.State
        var home: HomeFeature.State
        var myPage: MyPageMainFeature.State
        
        init(selectedTab: Tab = .home, isGuestMode: Bool = false) {
            self.isGuestMode = isGuestMode
            self.home = HomeFeature.State(isGuestMode: isGuestMode)
            self.knowledgeMap = KnowledgeMapFeature.State(isGuestMode: isGuestMode)
            self.myPage = MyPageMainFeature.State()
        }
    }

    enum Action {
        case selectedTabChanged(Tab)
        case guestMyPageAlertPresentedChanged(Bool)
        case guestLoginButtonTapped

        case knowledgeMap(KnowledgeMapFeature.Action)
        case home(HomeFeature.Action)
        case myPage(MyPageMainFeature.Action)
        
        case delegate(Delegate)
        enum Delegate {
            case loginRequested
            case logout
            case withdrawalCompleted
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.knowledgeMap, action: \.knowledgeMap) {
            KnowledgeMapFeature()
        }

        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Scope(state: \.myPage, action: \.myPage) {
            MyPageMainFeature()
        }

        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                guard !state.isGuestMode || tab != .myPage else {
                    state.isGuestMyPageAlertPresented = true
                    return .none
                }

                state.selectedTab = tab
                return .none

            case let .guestMyPageAlertPresentedChanged(isPresented):
                state.isGuestMyPageAlertPresented = isPresented
                return .none

            case .guestLoginButtonTapped:
                guard state.isGuestMode else { return .none }
                return .send(.delegate(.loginRequested))
                
            case .myPage(.delegate(.logoutSucceeded)):
                return .send(.delegate(.logout))

            case .myPage(.delegate(.withdrawalCompleted)):
                return .send(.delegate(.withdrawalCompleted))

            case .home(.delegate(.loginRequested)):
                return .send(.delegate(.loginRequested))

            case let .home(.delegate(.questionTapped(question))):
                return .send(.knowledgeMap(.openContent(categoryCode: question.categoryCode, contentID: question.contentID)))

            case .knowledgeMap(.delegate(.contentDestinationReady)):
                state.selectedTab = .knowledgeMap
                return .none

            case let .knowledgeMap(.delegate(.contentDestinationFailed(message))):
                state.home.errorMessage = message
                return .none
                
            case .knowledgeMap(.delegate(.loginRequested)):
                return .send(.delegate(.loginRequested))

            case .knowledgeMap, .home, .myPage, .delegate:
                return .none
            }
        }
    }
}
