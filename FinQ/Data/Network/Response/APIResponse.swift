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
}

struct APIErrorResponse: Decodable, Sendable, LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return message
    }
}
