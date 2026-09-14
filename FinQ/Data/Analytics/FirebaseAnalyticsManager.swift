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
}

final class FirebaseAnalyticsManager: FirebaseAnalyticsManagerProtocol, Sendable {
    static let shared = FirebaseAnalyticsManager()
    private init() { }
    
    func logPremiumContentTapped(contentID: Int, categoryCode: String) {
        Analytics.logEvent("premium_content_tapped", parameters: [
            "premium_content_tap_info": "\(categoryCode): \(contentID)",
        ])
    }
}
