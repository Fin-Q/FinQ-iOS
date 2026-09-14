import Foundation

extension NicknameUpdateResponse {
    func toDomain() -> String { nickname }
}

extension ProfileImageUpdateResponse {
    func toDomain() -> String { profileImageCode }
}
