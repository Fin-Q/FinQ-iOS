//
//  FindPasswordFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FindPasswordFeature {
    @Dependency(\.passwordResetVerificationUseCase) private var passwordResetVerificationUseCase

    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var isLoading: Bool = false
        var sendErrorMessage: String?

        var isSendButtonEnabled: Bool {
            return !isLoading && !email.replacingOccurrences(of: " ", with: "").isEmpty
        }
    }
    
    enum Action {
        case emailChanged(String)
        case sendButtonTapped
        case verificationSent(email: String, result: PasswordResetVerificationResult)
        case verificationFailed(String)
        case alertOKButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case pushToEmailVerificationView(email: String, verification: PasswordResetVerificationResult)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailChanged(let value):
                state.email = value
                return .none
                
            case .sendButtonTapped:
                guard state.isSendButtonEnabled else { return .none }

                let email = state.email
                state.isLoading = true
                state.sendErrorMessage = nil

                return .run { send in
                    do {
                        let result = try await passwordResetVerificationUseCase.sendVerification(loginID: email)
                        guard !Task.isCancelled else { return }

                        await send(.verificationSent(email: email, result: result))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.verificationFailed(error.localizedDescription))
                    }
                }

            case let .verificationSent(email, result):
                state.isLoading = false
                return .run { send in
                    var transaction = Transaction(animation: nil)
                    transaction.disablesAnimations = true
                    await send(.delegate(.pushToEmailVerificationView(email: email, verification: result)), transaction: transaction)
                }

            case let .verificationFailed(message):
                state.isLoading = false
                state.sendErrorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.sendErrorMessage = nil
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
