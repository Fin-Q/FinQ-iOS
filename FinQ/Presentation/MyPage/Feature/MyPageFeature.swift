import Foundation
import UserNotifications
import ComposableArchitecture

@Reducer
struct MyPageFeature {

    @Reducer
    enum Path {
        case profileEdit(ProfileEditFeature)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var nickname: String = ""
        var email: String = ""
        var interests: [InterestTopic] = []
        var profileImageCode: String = "PROFILE_01"
        var currentStreakDays: Int = 0
        var totalXp: Int = 0
        var notificationEnabled: Bool = false
        var isLoading: Bool = false
    }

    enum Action {
        case path(StackActionOf<Path>)
        case onAppear
        case userInfoResponse(Result<UserInfo, Error>)
        case profileEditButtonTapped
        case notificationToggled(Bool)
        case logoutButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case logoutSucceeded
        }
    }

    @Dependency(\.userInfoUseCase) var userInfoUseCase

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(.userInfoResponse(
                        Result { try await userInfoUseCase.fetchUserInfo() }
                    ))
                }

            case .userInfoResponse(.success(let userInfo)):
                state.isLoading = false
                state.nickname = userInfo.nickname
                state.email = userInfo.email
                state.interests = userInfo.interests
                state.profileImageCode = userInfo.profileImageCode
                state.currentStreakDays = userInfo.currentStreakDays
                state.totalXp = userInfo.totalXp
                state.notificationEnabled = userInfo.notificationEnabled
                return .run { [enabled = userInfo.notificationEnabled] _ in
                    if enabled {
                        await LocalNotificationManager.shared.scheduleDailyNotification()
                    } else {
                        LocalNotificationManager.shared.cancelDailyNotification()
                    }
                }

            case .userInfoResponse(.failure):
                state.isLoading = false
                state.nickname = KeychainManager.shared.getItem(forKey: .nickname) ?? "사용자"
                return .none

            case .profileEditButtonTapped:
                state.path.append(.profileEdit(ProfileEditFeature.State(
                    nickname: state.nickname,
                    email: state.email,
                    interests: state.interests,
                    profileImageCode: state.profileImageCode
                )))
                return .none

            case .notificationToggled(let enabled):
                state.notificationEnabled = enabled
                return .run { _ in
                    if enabled {
                        let center = UNUserNotificationCenter.current()
                        let granted = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
                        if granted {
                            await LocalNotificationManager.shared.scheduleDailyNotification()
                        }
                    } else {
                        LocalNotificationManager.shared.cancelDailyNotification()
                    }
                }

            case .logoutButtonTapped:
                return .run { send in
                    LocalNotificationManager.shared.cancelDailyNotification()
                    await send(.delegate(.logoutSucceeded))
                }

            case .path(.element(id: _, action: .profileEdit(.delegate(.nicknameUpdated(let name))))):
                state.nickname = name
                return .none

            case .path(.element(id: _, action: .profileEdit(.delegate(.profileImageUpdated(let code))))):
                state.profileImageCode = code
                return .none

            case .path(.element(id: _, action: .profileEdit(.delegate(.interestsUpdated(let topics))))):
                state.interests = topics
                return .none

            case .path, .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MyPageFeature.Path.State: Equatable {}
