//
//  APIResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation

struct APIResponse<Payload: Decodable & Sendable>: Decodable, Sendable {
    let status: String
    let message: String
    let data: Payload

    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)

        if let data = try container.decodeIfPresent(Payload.self, forKey: .data) {
            self.data = data
        } else if let emptyResponse = EmptyResponse() as? Payload {
            self.data = emptyResponse
        } else {
            self.data = try container.decode(Payload.self, forKey: .data)
        }
    }
}

struct APIErrorResponse: Decodable, Sendable, LocalizedError {
    let errorCode: String?
    let message: String
    let details: [APIErrorDetail]?

    init(errorCode: String? = nil, message: String, details: [APIErrorDetail]? = nil) {
        self.errorCode = errorCode
        self.message = message
        self.details = details
    }
    
    var errorDescription: String? {
        let reasons = details?.map(\.reason).filter { !$0.isEmpty } ?? []
        return reasons.isEmpty ? message : reasons.joined(separator: "\n")
    }
}

struct APIErrorDetail: Decodable, Sendable {
    let field: String
    let reason: String
}
