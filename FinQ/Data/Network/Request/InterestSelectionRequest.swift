//
//  InterestSelectionRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct InterestSelectionRequest: Encodable, Sendable {
    let interestTopicIds: [Int]
}
