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

    @State private var displayedRoute: AppFeature.Route
    @State private var activeTransitionID: UUID?

    init(store: StoreOf<AppFeature>) {
        self.store = store
        _displayedRoute = State(initialValue: store.route)
    }
    
    var body: some View {
        ZStack {
            switch displayedRoute {
            case .auth:
                AuthMainView(store: store.scope(\.auth, action: \.auth))
                    .transition(.opacity)

            case .onboarding:
                OnboardingView(store: store.scope(\.onboarding, action: \.onboarding))
                    .transition(.opacity)
                
            case .tabBar:
                TabBarView(store: store.scope(\.tabBar, action: \.tabBar))
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandWhite.ignoresSafeArea())
        .allowsHitTesting(activeTransitionID == nil)
        .onChange(of: store.route) { oldRoute, newRoute in
            transition(from: oldRoute, to: newRoute)
        }
    }

    private func transition(from oldRoute: AppFeature.Route, to newRoute: AppFeature.Route) {
        let transitionID = UUID()
        let shouldAnimate = newRoute == .onboarding || (oldRoute == .onboarding && newRoute == .tabBar)
        activeTransitionID = transitionID

        withAnimation(shouldAnimate ? .easeInOut(duration: 0.35) : nil, completionCriteria: .removed) {
            displayedRoute = newRoute
        } completion: {
            guard activeTransitionID == transitionID, store.route == newRoute else { return }

            activeTransitionID = nil
            store.send(.routeTransitionCompleted(newRoute))
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

#Preview("온보딩 흐름") {
    AppView(store: Store(initialState: AppFeature.State(route: .onboarding), reducer: { AppFeature() }))
}
