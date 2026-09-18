//
//  AdvancedQuizAnswerRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct AdvancedQuizAnswerRequest: Encodable, Sendable {
    let selectedOptionID: String

    enum CodingKeys: String, CodingKey {
        case selectedOptionID = "selectedOptionId"
    }
}
