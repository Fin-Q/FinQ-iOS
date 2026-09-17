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
        var isLogoutAlertPresented: Bool = false
        var isLoggingOut: Bool = false
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
        case logoutAlertCancelButtonTapped
        case logoutAlertConfirmButtonTapped
        case logoutSucceeded
        case logoutFailed(String)
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
                state.isLogoutAlertPresented = true
                return .none

            case .logoutAlertCancelButtonTapped:
                state.isLogoutAlertPresented = false
                return .none

            case .logoutAlertConfirmButtonTapped:
                guard !state.isLoggingOut else { return .none }
                state.isLogoutAlertPresented = false
                state.isLoggingOut = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await myPageUseCase.logout()
                        await send(.logoutSucceeded)
                    } catch {
                        await send(.logoutFailed(error.localizedDescription))
                    }
                }

            case .logoutSucceeded:
                state.isLoggingOut = false
                return .send(.delegate(.logoutSucceeded))

            case let .logoutFailed(message):
                state.isLoggingOut = false
                state.errorMessage = message
                return .none
                
            case .withdrawalButtonTapped:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
