//
//  FinQApp.swift
//  FinQ
//
//  Created by 권대윤 on 8/23/26.
//

import SwiftUI
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
}
