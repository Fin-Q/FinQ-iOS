//
//  HapticManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import UIKit

@MainActor
enum HapticManager {
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func impact(intensity: CGFloat) {
        let generator = UIImpactFeedbackGenerator()
        let intensity = min(max(intensity, 0), 1)

        generator.impactOccurred(intensity: intensity)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
