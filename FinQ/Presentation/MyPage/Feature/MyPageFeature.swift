//
//  MyPageFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase
    private enum CancelID { case fetchMyPage }

    @ObservableState
    struct State: Equatable {
        var myPage: MyPageSummary?
        var isNotificationEnabled: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case fetchMyPageSucceeded(MyPageSummary)
        case fetchMyPageFailed(String)
        case interestButtonTapped(MyPageInterest)
        case profileEditButtonTapped
        case serviceTermsButtonTapped
        case privacyPolicyButtonTapped
        case notificationChanged(Bool)
        case alertOKButtonTapped
        case logoutButtonTapped
        case withdrawalButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case logoutSucceeded
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let myPage = try await myPageUseCase.fetchMyPage()
                        guard !Task.isCancelled else { return }
                        await send(.fetchMyPageSucceeded(myPage))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchMyPageFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchMyPage, cancelInFlight: true)

            case .onDisappear:
                state.isLoading = false
                return .cancel(id: CancelID.fetchMyPage)

            case let .fetchMyPageSucceeded(myPage):
                state.myPage = myPage
                state.isNotificationEnabled = myPage.notificationEnabled
                state.isLoading = false
                return .none

            case let .fetchMyPageFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .interestButtonTapped, .profileEditButtonTapped, .serviceTermsButtonTapped, .privacyPolicyButtonTapped:
                return .none

            case let .notificationChanged(isEnabled):
                state.isNotificationEnabled = isEnabled
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .logoutButtonTapped:
                return .none
                
            case .withdrawalButtonTapped:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
