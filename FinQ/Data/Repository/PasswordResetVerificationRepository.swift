//
//  PasswordResetVerificationRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct PasswordResetVerificationRepository: PasswordResetVerificationRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func sendVerification(input: PasswordResetVerificationInput) async throws -> PasswordResetVerificationResult {
        let response = try await networkManager.perform(api: .sendPasswordResetVerification(input.toRequest()), responseType: APIResponse<PasswordResetVerificationResponse>.self)
        return response.data.toDomain()
    }
}
