//
//  ContentAnswerRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

struct ContentAnswerRequest: Encodable, Sendable {
    let selectedOptionID: String

    enum CodingKeys: String, CodingKey {
        case selectedOptionID = "selectedOptionId"
    }
}
