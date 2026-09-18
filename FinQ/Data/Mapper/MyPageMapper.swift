//
//  MyPageMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

extension MyPageResponse {
    func toDomain() -> MyPageSummary {
        return MyPageSummary(userID: userID, email: email, nickname: nickname, profileImageCode: profileImageCode, profileImageURL: profileImageURL, totalXP: totalXP, currentStreakDays: currentStreakDays, notificationEnabled: notificationEnabled, interests: interests.map { $0.toDomain() })
    }
}

private extension MyPageInterestResponse {
    func toDomain() -> MyPageInterest {
        return MyPageInterest(categoryID: categoryID, categoryCode: categoryCode, categoryName: categoryName)
    }
}
