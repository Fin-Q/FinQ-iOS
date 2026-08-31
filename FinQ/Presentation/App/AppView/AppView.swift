//
//  AppView.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        switch store.route {
        case .auth:
            AuthMainView(store: store.scope(\.auth, action: \.auth))
            
        case .tabBar:
            TabBarView(store: store.scope(\.tabBar, action: \.tabBar))
        }
    }
}

#Preview("인증 화면") {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}

#Preview("탭바 화면") {
    AppView(store: Store(initialState: AppFeature.State(route: .tabBar)) {
        AppFeature()
    })
}
