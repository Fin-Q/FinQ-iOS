import Foundation

struct NicknameUpdateResponse: Decodable, Sendable {
    let nickname: String
    let updatedAt: String
}
