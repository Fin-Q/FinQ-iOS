//
//  FinQApp.swift
//  FinQ
//
//  Created by 권대윤 on 8/23/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct FinQApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}
