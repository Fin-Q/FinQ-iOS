//
//  OnboardingMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

extension InterestSelectionInput {
    func toRequest() -> InterestSelectionRequest {
        return InterestSelectionRequest(interestTopicIds: topics.map(\.id).sorted())
    }
}
