//
//  TabBarView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct TabBarView: View {
    @Bindable var store: StoreOf<TabBarFeature>

    init(store: StoreOf<TabBarFeature>) {
        self.store = store
        UITabBar.appearance().unselectedItemTintColor = .black
    }

    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
            HomeView(store: store.scope(\.home, action: \.home))
            .tabItem {
                Label { Text("홈") } icon: { Image("home").renderingMode(.template) }
            }
            .tag(TabBarFeature.Tab.home)

            KnowledgeMapView(store: store.scope(\.knowledgeMap, action: \.knowledgeMap))
            .tabItem {
                Label { Text("지식맵") } icon: { Image("knowledgeMap").renderingMode(.template) }
            }
            .tag(TabBarFeature.Tab.knowledgeMap)

            MyPageView(store: store.scope(\.myPage, action: \.myPage))
            .tabItem {
                Label { Text("마이페이지") } icon: { Image("myPage").renderingMode(.template) }
            }
            .tag(TabBarFeature.Tab.myPage)
        }
        .tint(.black)
    }
}

#Preview {
    TabBarView(
        store: Store(initialState: TabBarFeature.State()) {
            TabBarFeature()
        }
    )
}
