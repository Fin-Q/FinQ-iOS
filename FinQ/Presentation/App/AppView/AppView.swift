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
        ZStack {
            switch store.route {
            case .auth:
                AuthMainView(store: store.scope(\.auth, action: \.auth))
                    .transition(.opacity)
                    .onDidDisappear { store.send(.authViewDidDisappear) }

            case .onboarding:
                OnboardingView(store: store.scope(\.onboarding, action: \.onboarding))
                
            case .tabBar:
                TabBarView(store: store.scope(\.tabBar, action: \.tabBar))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(store.route == .onboarding ? .easeInOut(duration: 0.35) : nil, value: store.route)
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

#Preview("온보딩 흐름") {
    AppView(store: Store(initialState: AppFeature.State(route: .onboarding), reducer: { AppFeature() }))
}
