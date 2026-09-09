//
//  EmailVerificationFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EmailVerificationFeature {
    @Dependency(\.passwordResetVerificationUseCase) private var passwordResetVerificationUseCase
    @Dependency(\.continuousClock) var clock

    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var verificationID: String = ""
        var code: String = ""
        var verificationState: VerificationState = .progress
        var isResending: Bool = false
        var resendErrorMessage: String?
        
        var seconds: Int = 180
        var resendAvailableIn: Int = 0

        var secondsText: String {
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }

        var isResendButtonEnabled: Bool { !isResending && resendAvailableIn == 0 && !email.isEmpty }
    }
    
    enum Action {
        case codeChanged(String)
        case task
        case timerTick
        case resendButtonTapped
        case verificationResent(PasswordResetVerificationResult)
        case resendFailed(String)
        case alertOKButtonTapped
        case nextButtonTapped
        case onDisappear
        
        case delegate(Delegate)
        enum Delegate {
            case pushToNewPasswordView
        }
    }
    
    enum VerificationState {
        case progress
        case timeout
        case error
    }
    
    private enum CancelID { case timer, resend }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .codeChanged(let value):
                state.code = value
                return .none
                
            case .task:
                let remainingTicks = max(0, max(state.seconds, state.resendAvailableIn))
                if state.seconds == 0 { state.verificationState = .timeout }
                guard remainingTicks > 0 else { return .cancel(id: CancelID.timer) }

                return .run { [clock] send in
                    for await _ in clock.timer(interval: .seconds(1)).prefix(remainingTicks) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .resendButtonTapped:
                guard state.isResendButtonEnabled else { return .none }

                let email = state.email
                state.isResending = true
                state.resendErrorMessage = nil

                return .run { send in
                    do {
                        let result = try await passwordResetVerificationUseCase.sendVerification(loginID: email)
                        guard !Task.isCancelled else { return }

                        await send(.verificationResent(result))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.resendFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.resend, cancelInFlight: true)

            case let .verificationResent(result):
                state.isResending = false
                state.verificationID = result.verificationID
                state.code = ""
                state.seconds = max(0, result.expiresIn)
                state.resendAvailableIn = max(0, result.resendAvailableIn)
                state.verificationState = state.seconds > 0 ? .progress : .timeout
                return .send(.task)

            case let .resendFailed(message):
                state.isResending = false
                state.resendErrorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.resendErrorMessage = nil
                return .none
                
            case .timerTick:
                state.seconds = max(0, state.seconds - 1)
                state.resendAvailableIn = max(0, state.resendAvailableIn - 1)
                if state.seconds == 0 { state.verificationState = .timeout }
                return .none
                
            case .nextButtonTapped:
                return .send(.delegate(.pushToNewPasswordView))
                
            case .onDisappear:
                state.isResending = false
                return .merge(.cancel(id: CancelID.timer), .cancel(id: CancelID.resend))
                
            case .delegate:
                return .none
            }
        }
    }
}
