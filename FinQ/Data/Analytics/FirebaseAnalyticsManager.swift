//
//  FirebaseAnalyticsManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import FirebaseAnalytics

protocol FirebaseAnalyticsManagerProtocol: Sendable {
    func logPremiumContentTapped(contentID: Int, categoryCode: String)
    func logFirstLearningStart(contentID: Int, categoryCode: String)
    func logFirstLearningComplete(contentID: Int, categoryCode: String)
}

final class FirebaseAnalyticsManager: FirebaseAnalyticsManagerProtocol, Sendable {
    static let shared = FirebaseAnalyticsManager()
    private init() { }
    
    func logPremiumContentTapped(contentID: Int, categoryCode: String) {
        Analytics.logEvent("premium_content_tapped", parameters: [
            "premium_content_tap_info": "\(categoryCode): \(contentID)",
        ])
    }

    /// 모든 카테고리 모든 콘텐츠 중 완료한게 없는 경우 -> 첫 학습 진행으로 판단하여 수집
    func logFirstLearningStart(contentID: Int, categoryCode: String) {
        Analytics.logEvent("first_learning_start", parameters: [
            "first_learning_start": "\(categoryCode): \(contentID)",
        ])
    }

    /// 모든 카테고리 모든 콘텐츠 중 완료한게 없는 첫 학습 진행자가 학습 완료할 경우 수집
    func logFirstLearningComplete(contentID: Int, categoryCode: String) {
        Analytics.logEvent("first_learning_complete", parameters: [
            "first_learning_complete": "\(categoryCode): \(contentID)",
        ])
    }
}
