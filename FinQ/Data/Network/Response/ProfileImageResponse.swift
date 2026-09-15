//
//  ProfileImageResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct ProfileImageResponse: Decodable, Sendable {
    let profileImageCode: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case profileImageCode
        case profileImageURL = "profileImageUrl"
    }
}
