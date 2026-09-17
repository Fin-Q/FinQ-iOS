//
//  MyPageProfileEditFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageProfileEditFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase

    @ObservableState
    struct State: Equatable {
        var myPage: MyPageSummary
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case profileImageButtonTapped
        case nicknameButtonTapped
        case interestButtonTapped
        case refresh
        case fetchMyPageSucceeded(MyPageSummary)
        case fetchMyPageFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case profileImageSelectionRequested(String)
            case nicknameEditRequested(String)
            case interestSelectionRequested([MyPageInterest])
            case myPageUpdated(MyPageSummary)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .profileImageButtonTapped:
                return .send(.delegate(.profileImageSelectionRequested(state.myPage.profileImageCode)))

            case .nicknameButtonTapped:
                return .send(.delegate(.nicknameEditRequested(state.myPage.nickname)))

            case .interestButtonTapped:
                return .send(.delegate(.interestSelectionRequested(state.myPage.interests)))

            case .refresh:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let myPage = try await myPageUseCase.fetchMyPage()
                        await send(.fetchMyPageSucceeded(myPage))
                    } catch {
                        await send(.fetchMyPageFailed(error.localizedDescription))
                    }
                }

            case let .fetchMyPageSucceeded(myPage):
                state.myPage = myPage
                state.isLoading = false
                return .send(.delegate(.myPageUpdated(myPage)))

            case let .fetchMyPageFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
