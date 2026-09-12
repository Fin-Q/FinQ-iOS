//
//  FinQApp.swift
//  FinQ
//
//  Created by 권대윤 on 8/23/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct FinQApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    init() {
        Self.configureNavigationBarAppearance()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
                .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }

    private static func configureNavigationBarAppearance() {
        let backIndicatorImage = UIImage(resource: .chevronLeft).withTintColor(UIColor(Color.brandGray300), renderingMode: .alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8))
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)

        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = UIColor(Color.brandGray300)
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationBar.compactAppearance = navigationBarAppearance
        navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
