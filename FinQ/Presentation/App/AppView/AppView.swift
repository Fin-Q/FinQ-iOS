//
//  AppView.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import SwiftUI
import Combine
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
            case .launching:
                SplashView()

            case .auth:
                AuthMainView(store: store.scope(\.auth, action: \.auth))
                    .transition(.opacity)

            case .onboarding:
                OnboardingView(store: store.scope(\.onboarding, action: \.onboarding))
                    .transition(.opacity)
                
            case .tabBar:
                MainTabBarContainerView(store: store.scope(\.tabBar, action: \.tabBar))
                    .transition(.opacity)
            }

            SplashView()
                .opacity(store.isWaitingForInitialHome ? 1 : 0)
                .allowsHitTesting(store.isWaitingForInitialHome)
                .accessibilityHidden(!store.isWaitingForInitialHome)
                .animation(store.isWaitingForInitialHome ? nil : .easeOut(duration: 0.35), value: store.isWaitingForInitialHome)
                .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandWhite.ignoresSafeArea())
        .allowsHitTesting(activeTransitionID == nil)
        .task { store.send(.onAppear) }
        .onReceive(NotificationCenter.default.publisher(for: .tokenRefreshFailed).receive(on: DispatchQueue.main)) { _ in
            store.send(.tokenRefreshFailed)
        }
        .onChange(of: store.route) { oldRoute, newRoute in
            transition(from: oldRoute, to: newRoute)
        }
    }

    private func transition(from oldRoute: AppFeature.Route, to newRoute: AppFeature.Route) {
        let transitionID = UUID()
        let shouldAnimate = (oldRoute == .launching && newRoute == .auth) || newRoute == .onboarding || (oldRoute == .onboarding && newRoute == .tabBar)
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
    AppView(store: Store(initialState: AppFeature.State(route: .auth)) {
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
