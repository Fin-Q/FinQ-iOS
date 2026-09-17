//
//  MyPageSummary.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

struct MyPageSummary: Equatable, Sendable {
    let userID: String
    let email: String
    let nickname: String
    let profileImageCode: String
    let profileImageURL: String
    let totalXP: Int
    let currentStreakDays: Int
    let notificationEnabled: Bool
    let interests: [MyPageInterest]
}

struct MyPageInterest: Identifiable, Equatable, Sendable {
    let categoryID: Int
    let categoryCode: String
    let categoryName: String

    var id: Int { categoryID }
}
