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
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var code: String = ""
        var verificationState: VerificationState = .progress
        
        var seconds: Int = 180
        var secondsText: String {
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }
    }
    
    enum Action {
        case codeChanged(String)
        case task
        case timerTick
        case resendButtonTapped
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
    
    private enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .codeChanged(let value):
                state.code = value
                return .none
                
            case .task:
                return .run { [clock, seconds = state.seconds] send in
                    for await _ in clock.timer(interval: .seconds(1)).prefix(seconds) {
                        await send(.timerTick)
                    }
                }
                
            case .resendButtonTapped:
                state.verificationState = .progress
                state.seconds = 180
                return .send(.task)
                
            case .timerTick:
                state.seconds = max(0, state.seconds - 1)
                if state.seconds == 0 { state.verificationState = .timeout }
                return .none
                
            case .nextButtonTapped:
                return .send(.delegate(.pushToNewPasswordView))
                
            case .onDisappear:
                return .cancel(id: CancelID.timer)
                
            case .delegate:
                return .none
            }
        }
    }
}
