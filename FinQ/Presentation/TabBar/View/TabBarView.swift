//
//  TabBarView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    @Bindable var store: StoreOf<TabBarFeature>

    var body: some View {
        VStack(spacing: 0) {
            selectedContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if shouldShowTabBar {
                AppTabBar(selectedTab: store.selectedTab) { store.send(.selectedTabChanged($0)) }
            }
        }
        .background(Color.brandWhite.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch store.selectedTab {
        case .home:
            HomeView(store: store.scope(\.home, action: \.home))

        case .knowledgeMap:
            KnowledgeMapView(store: store.scope(\.knowledgeMap, action: \.knowledgeMap))

        case .myPage:
            MyPageView(store: store.scope(\.myPage, action: \.myPage))
        }
    }
    
    private var shouldShowTabBar: Bool {
        switch store.selectedTab {
        case .knowledgeMap:
            return store.knowledgeMap.path.isEmpty

        case .home, .myPage:
            return true
        }
    }
}

#Preview {
    TabBarView(
        store: Store(initialState: TabBarFeature.State()) {
            TabBarFeature()
        }
    )
}
