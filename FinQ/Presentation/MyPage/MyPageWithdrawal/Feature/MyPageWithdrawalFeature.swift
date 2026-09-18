//
//  MyPageWithdrawalFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageWithdrawalFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase
    @Dependency(\.loginUseCase) private var loginUseCase

    @ObservableState
    struct State: Equatable {
        var isAgreementChecked: Bool = false
        var isWithdrawing: Bool = false
        var errorMessage: String?

        var isWithdrawalButtonEnabled: Bool { isAgreementChecked && !isWithdrawing }
    }

    enum Action {
        case agreementButtonTapped
        case withdrawalButtonTapped
        case withdrawalSucceeded
        case withdrawalFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .agreementButtonTapped:
                guard !state.isWithdrawing else { return .none }
                state.isAgreementChecked.toggle()
                return .none

            case .withdrawalButtonTapped:
                guard state.isWithdrawalButtonEnabled else { return .none }
                state.isWithdrawing = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await myPageUseCase.withdraw()
                        loginUseCase.clearSession()
                        await send(.withdrawalSucceeded)
                    } catch {
                        await send(.withdrawalFailed(error.localizedDescription))
                    }
                }

            case .withdrawalSucceeded:
                state.isWithdrawing = false
                return .send(.delegate(.completed))

            case let .withdrawalFailed(message):
                state.isWithdrawing = false
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
