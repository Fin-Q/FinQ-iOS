import Foundation

struct RewardStatusResponse: Decodable, Sendable {
    let totalXp: Int
    let level: Int
    let characterStage: Int
}
