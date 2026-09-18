//
//  MyPageProfileImageSelectionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

enum MyPageProfileImageOption: String, CaseIterable, Identifiable, Sendable {
    case profile01 = "PROFILE_01"
    case profile02 = "PROFILE_02"
    case profile03 = "PROFILE_03"
    case profile04 = "PROFILE_04"

    var id: String { rawValue }
    var assetName: String { rawValue.lowercased().replacingOccurrences(of: "_", with: "") }
}

@Reducer
struct MyPageProfileImageSelectionFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase

    @ObservableState
    struct State: Equatable {
        var selectedOption: MyPageProfileImageOption
        var isSaving: Bool = false
        var errorMessage: String?

        init(profileImageCode: String) {
            self.selectedOption = MyPageProfileImageOption(rawValue: profileImageCode) ?? .profile01
        }
    }

    enum Action {
        case profileImageTapped(MyPageProfileImageOption)
        case completeButtonTapped
        case updateProfileImageSucceeded
        case updateProfileImageFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .profileImageTapped(option):
                guard !state.isSaving else { return .none }
                state.selectedOption = option
                return .none

            case .completeButtonTapped:
                guard !state.isSaving else { return .none }
                let profileImageCode = state.selectedOption.rawValue
                state.isSaving = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await myPageUseCase.updateProfileImage(code: profileImageCode)
                        await send(.updateProfileImageSucceeded)
                    } catch {
                        await send(.updateProfileImageFailed(error.localizedDescription))
                    }
                }

            case .updateProfileImageSucceeded:
                state.isSaving = false
                return .send(.delegate(.completed))

            case let .updateProfileImageFailed(message):
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
