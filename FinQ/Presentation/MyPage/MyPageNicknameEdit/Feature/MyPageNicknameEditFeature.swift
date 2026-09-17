//
//  MyPageNicknameEditFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageNicknameEditFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase

    @ObservableState
    struct State: Equatable {
        var nickname: String
        var isSaving: Bool = false
        var errorMessage: String?

        init(nickname: String = "") {
            self.nickname = nickname
        }

        var trimmedNickname: String { nickname.trimmingCharacters(in: .whitespacesAndNewlines) }
        var isNicknameValid: Bool {
            let nickname = trimmedNickname
            guard (2...7).contains(nickname.count) else { return false }
            return nickname.range(of: #"^[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9 ]+$"#, options: .regularExpression) != nil
        }
        var showsNicknameValidationError: Bool { !nickname.isEmpty && !isNicknameValid }
        var isCompleteButtonEnabled: Bool { isNicknameValid && !isSaving }
    }

    enum Action {
        case nicknameChanged(String)
        case clearButtonTapped
        case completeButtonTapped
        case updateNicknameSucceeded
        case updateNicknameFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .nicknameChanged(nickname):
                state.nickname = nickname
                return .none

            case .clearButtonTapped:
                state.nickname = ""
                return .none

            case .completeButtonTapped:
                guard state.isCompleteButtonEnabled else { return .none }
                let nickname = state.trimmedNickname
                state.nickname = nickname
                state.isSaving = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await myPageUseCase.updateNickname(nickname)
                        await send(.updateNicknameSucceeded)
                    } catch {
                        await send(.updateNicknameFailed(error.localizedDescription))
                    }
                }

            case .updateNicknameSucceeded:
                state.isSaving = false
                return .send(.delegate(.completed))

            case let .updateNicknameFailed(message):
                state.isSaving = false
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
