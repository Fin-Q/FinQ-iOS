//
//  AppDelegate.swift
//  FinQ
//
//  Created by 권대윤 on 8/23/26.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func setupUserNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
    }
    
    // 포그라운드에서 알림 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AppLogger.shared.log("푸시 알림 수신: \(notification.request.content.userInfo)", level: .debug)
        completionHandler([.banner, .sound, .badge, .list])
    }
    
    // APNs 토큰과 FCM 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }
        let tokenString = tokenParts.joined()
        AppLogger.shared.log("디바이스 토큰: \(tokenString)", level: .debug)
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 사용자가 알림을 클릭했을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        AppLogger.shared.log("푸시 알림 클릭됨: \(userInfo)", level: .debug)
//        NotificationCenter.default.post(name: .didReceivePushNotification, object: nil, userInfo: userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AppLogger.shared.log("APNs 등록 실패: \(error)", level: .error)
    }
}

//MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // FCM 토큰 갱신
        AppLogger.shared.log("FCM 토큰: \(fcmToken ?? "nil")", level: .debug)
        
        guard let fcmToken else { return }
        _ = KeychainManager.shared.saveItem(item: fcmToken, forKey: .fcmToken)
    }
}
