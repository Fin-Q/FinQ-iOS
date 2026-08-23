//
//  FinQApp.swift
//  FinQ
//
//  Created by 권대윤 on 8/23/26.
//

import SwiftUI

@main
struct FinQApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
