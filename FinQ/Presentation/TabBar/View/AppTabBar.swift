//
//  AppTabBar.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation
import SwiftUI

struct AppTabBar: View {
    let selectedTab: TabBarFeature.Tab
    let onSelect: (TabBarFeature.Tab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            Spacer(minLength: 0)
            tabButton(.knowledgeMap)
            Spacer(minLength: 0)
            tabButton(.myPage)
        }
        .padding(.horizontal, 55)
        .frame(height: 72)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16)
                .fill(Color.brandWhite)
                .ignoresSafeArea(edges: .bottom)
        }
        .overlay { TabBarTopBorder().stroke(Color.brandGray300.opacity(0.35), lineWidth: 1) }
    }

    private func tabButton(_ tab: TabBarFeature.Tab) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            guard !isSelected else { return }
            HapticManager.selection()
            onSelect(tab)
        } label: {
            VStack(spacing: 5) {
                Image(tab.imageName)
                    .renderingMode(.template)

                Text(tab.title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                    .fixedSize(horizontal: true, vertical: false)
            }
            .foregroundStyle(isSelected ? Color.brandBlack : Color.brandGray300)
            .frame(width: 44, height: 72)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct TabBarTopBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + 16))
        path.addQuadCurve(to: CGPoint(x: rect.minX + 16, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 16, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 16), control: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}

private extension TabBarFeature.Tab {
    var title: String {
        switch self {
        case .home: "홈"
        case .knowledgeMap: "지식맵"
        case .myPage: "마이페이지"
        }
    }

    var imageName: String {
        switch self {
        case .home: "home"
        case .knowledgeMap: "knowledgeMap"
        case .myPage: "myPage"
        }
    }
}
