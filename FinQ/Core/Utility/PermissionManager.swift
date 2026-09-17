//
//  PermissionManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import UserNotifications

enum NotificationPermissionStatus: Equatable, Sendable {
    case authorized
    case denied
    case notDetermined
}

protocol PermissionManagerProtocol: Sendable {
    func notificationPermissionStatus() async -> NotificationPermissionStatus
    func requestNotificationPermission() async throws -> Bool
}

final class PermissionManager: PermissionManagerProtocol, Sendable {
    static let shared = PermissionManager()
    private init() { }

    func notificationPermissionStatus() async -> NotificationPermissionStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    func requestNotificationPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    }
}
