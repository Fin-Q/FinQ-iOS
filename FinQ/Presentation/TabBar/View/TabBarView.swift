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

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
            StudyView(store: store.scope(\.study, action: \.study))
                .tabItem { Label("학습", systemImage: "book.closed") }
                .tag(TabBarFeature.Tab.study)

            HomeView(store: store.scope(\.home, action: \.home))
                .tabItem { Label("홈", systemImage: "house") }
                .tag(TabBarFeature.Tab.home)

            MyPageView(store: store.scope(\.myPage, action: \.myPage))
                .tabItem { Label("마이페이지", systemImage: "person.crop.circle") }
                .tag(TabBarFeature.Tab.myPage)
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
