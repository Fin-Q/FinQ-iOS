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
    
    static let store = Store(initialState: TabBarFeature.State()) {
        TabBarFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(store: Self.store)
        }
    }
}
