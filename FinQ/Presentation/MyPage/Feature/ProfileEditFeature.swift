import Foundation
import ComposableArchitecture

@Reducer
struct ProfileEditFeature {

    @ObservableState
    struct State: Equatable {
        var nickname: String
        var email: String
        var interests: [InterestTopic]
        var profileImageCode: String
        var isEditingNickname: Bool = false
        var editNicknameText: String = ""
        var isSelectingImage: Bool = false
        var isSelectingInterests: Bool = false
        var selectedInterests: Set<InterestTopic> = []
        var isLoading: Bool = false
        var nicknameError: String? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nicknameTapped
        case profileImageTapped
        case interestsTapped
        case interestToggled(InterestTopic)
        case confirmInterestSelection
        case dismissInterestSelection
        case confirmNicknameEdit
        case dismissNicknameEdit
        case profileImageSelected(String)
        case dismissImagePicker
        case updateNicknameResponse(Result<String, Error>)
        case updateProfileImageResponse(Result<String, Error>)
        case updateInterestsResponse(Result<Void, Error>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case nicknameUpdated(String)
            case profileImageUpdated(String)
            case interestsUpdated([InterestTopic])
        }
    }

    @Dependency(\.profileUseCase) var profileUseCase

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .nicknameTapped:
                state.editNicknameText = state.nickname
                state.nicknameError = nil
                state.isEditingNickname = true
                return .none

            case .profileImageTapped:
                state.isSelectingImage = true
                return .none

            case .interestsTapped:
                state.selectedInterests = Set(state.interests)
                state.isSelectingInterests = true
                return .none

            case .interestToggled(let topic):
                if state.selectedInterests.contains(topic) {
                    state.selectedInterests.remove(topic)
                } else {
                    state.selectedInterests.insert(topic)
                }
                return .none

            case .confirmInterestSelection:
                guard !state.selectedInterests.isEmpty else { return .none }
                let topics = InterestTopic.allCases.filter { state.selectedInterests.contains($0) }
                state.isSelectingInterests = false
                state.isLoading = true
                return .run { [topics] send in
                    await send(.updateInterestsResponse(
                        Result { try await profileUseCase.updateInterests(topics) }
                    ))
                }

            case .dismissInterestSelection:
                state.isSelectingInterests = false
                return .none

            case .confirmNicknameEdit:
                let trimmed = state.editNicknameText.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty {
                    state.nicknameError = "닉네임을 입력해주세요."
                    return .none
                }
                if trimmed.count > 15 {
                    state.nicknameError = "닉네임은 최대 15자까지 입력할 수 있어요."
                    return .none
                }
                state.isLoading = true
                state.isEditingNickname = false
                return .run { [nickname = trimmed] send in
                    await send(.updateNicknameResponse(
                        Result { try await profileUseCase.updateNickname(nickname) }
                    ))
                }

            case .dismissNicknameEdit:
                state.isEditingNickname = false
                state.nicknameError = nil
                return .none

            case .profileImageSelected(let code):
                state.isSelectingImage = false
                state.isLoading = true
                return .run { send in
                    await send(.updateProfileImageResponse(
                        Result { try await profileUseCase.updateProfileImage(code) }
                    ))
                }

            case .dismissImagePicker:
                state.isSelectingImage = false
                return .none

            case .updateNicknameResponse(.success(let nickname)):
                state.isLoading = false
                state.nickname = nickname
                return .send(.delegate(.nicknameUpdated(nickname)))

            case .updateNicknameResponse(.failure):
                state.isLoading = false
                return .none

            case .updateProfileImageResponse(.success(let code)):
                state.isLoading = false
                state.profileImageCode = code
                return .send(.delegate(.profileImageUpdated(code)))

            case .updateProfileImageResponse(.failure):
                state.isLoading = false
                return .none

            case .updateInterestsResponse(.success):
                state.isLoading = false
                let topics = InterestTopic.allCases.filter { state.selectedInterests.contains($0) }
                state.interests = topics
                return .send(.delegate(.interestsUpdated(topics)))

            case .updateInterestsResponse(.failure):
                state.isLoading = false
                return .none

            case .binding, .delegate:
                return .none
            }
        }
    }
}
