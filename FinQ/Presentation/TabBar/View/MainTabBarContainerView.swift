//
//  MainTabBarContainerView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import SwiftUI
import ComposableArchitecture

struct MainTabBarContainerView: View {
    @Bindable var store: StoreOf<TabBarFeature>

    var body: some View {
        ZStack(alignment: .bottom) {
            selectedContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            bottomBar
        }
        .background {
            Color.brandWhite.ignoresSafeArea()
            if store.selectedTab == .home {
                if store.home.path.isEmpty {
                    Color.brandSkyBlue.ignoresSafeArea(edges: .top)
                } else {
                    Color.brandLightGray.ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .customGuestLoginAlert(isPresented: Binding(get: { store.isGuestMyPageAlertPresented }, set: { store.send(.guestMyPageAlertPresentedChanged($0)) }), title: "로그인하고 나만의 마이페이지를\n만들어보세요", onPrimary: {
            HapticManager.selection()
            store.send(.guestLoginButtonTapped)
        }, onCancel: {
            HapticManager.selection()
        })
    }

    @ViewBuilder
    private var bottomBar: some View {
        if shouldShowTabBar {
            AppTabBar(selectedTab: store.selectedTab) { store.send(.selectedTabChanged($0)) }
        }
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch store.selectedTab {
        case .home:
            HomeView(store: store.scope(\.home, action: \.home))

        case .knowledgeMap:
            KnowledgeMapView(store: store.scope(\.knowledgeMap, action: \.knowledgeMap))

        case .myPage:
            MyPageMainView(store: store.scope(\.myPage, action: \.myPage))
        }
    }
    
    private var shouldShowTabBar: Bool {
        switch store.selectedTab {
        case .knowledgeMap:
            return store.knowledgeMap.path.isEmpty

        case .home:
            return store.home.path.isEmpty

        case .myPage:
            return store.myPage.path.isEmpty
        }
    }
}

#Preview {
    MainTabBarContainerView(
        store: Store(initialState: TabBarFeature.State()) {
            TabBarFeature()
        }
    )
}
