import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature {

    @Reducer
    enum Path {
        case streakDetail(StreakDetailFeature)
        case notification(NotificationFeature)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var nickname: String = ""
        var level: Int = 1
        var totalXp: Int = 0
        var characterStage: Int = 1
        var currentStreak: Int = 0
        var questions: [QuestionCard] = []
        var isLoading: Bool = false
    }

    enum Action {
        case path(StackActionOf<Path>)
        case onAppear
        case homeResponse(Result<HomeData, Error>)
        case rewardStatusResponse(Result<RewardStatus, Error>)
        case notificationButtonTapped
        case streakButtonTapped
        case questionTapped(QuestionCard)
    }

    @Dependency(\.homeUseCase) var homeUseCase
    @Dependency(\.rewardUseCase) var rewardUseCase

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    async let homeResult = Result { try await homeUseCase.fetchHome() }
                    async let rewardResult = Result { try await rewardUseCase.fetchRewardStatus() }
                    await send(.homeResponse(await homeResult))
                    await send(.rewardStatusResponse(await rewardResult))
                }

            case .homeResponse(.success(let homeData)):
                state.isLoading = false
                state.nickname = homeData.nickname
                state.currentStreak = homeData.currentStreak
                state.questions = homeData.questions
                return .none

            case .homeResponse(.failure):
                state.isLoading = false
                state.nickname = KeychainManager.shared.getItem(forKey: .nickname) ?? "사용자"
                return .none

            case .rewardStatusResponse(.success(let reward)):
                state.level = reward.level
                state.totalXp = reward.totalXp
                state.characterStage = reward.characterStage
                return .none

            case .rewardStatusResponse(.failure):
                return .none

            case .notificationButtonTapped:
                state.path.append(.notification(NotificationFeature.State()))
                return .none

            case .streakButtonTapped:
                state.path.append(.streakDetail(StreakDetailFeature.State()))
                return .none

            case .questionTapped:
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension HomeFeature.Path.State: Equatable {}
