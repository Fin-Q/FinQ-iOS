//
//  AdvancedQuizCompletionSummaryView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AdvancedQuizCompletionSummaryView: View {
    let store: StoreOf<AdvancedQuizCompletionSummaryFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(store.quiz.completionTitle)
                        .font(AppDesign.Fonts.largeTitleSemiBold24)
                        .foregroundStyle(Color.brandBlack)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)

                    completionCard
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 16)
        .background(Color.brandWhite.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                HapticManager.selection()
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .buttonStyle(.customDefault)
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
            .background(Color.brandWhite)
        }
        .enableInteractivePopGesture()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var backButton: some View {
        Button {
            HapticManager.selection()
            store.send(.backButtonTapped)
        } label: {
            Image(.chevronLeft)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundStyle(Color.brandGray300)
                .frame(width: 44, height: 44, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("뒤로가기")
    }

    private var completionCard: some View {
        let content = store.quiz.completionDescription.markdownBulletList()

        return VStack(alignment: .leading, spacing: 20) {
            if !content.introduction.isEmpty {
                Text(content.introduction.markdownAttributedString(collapseParagraphBreaks: true))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.brandDarkGray)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ForEach(Array(content.items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 14) {
                    Image(.checkBlue)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(Color.brandGray300)
                        .padding(.top, 3)

                    Text(item.markdownAttributedString(collapseParagraphBreaks: true))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.brandDarkGray)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
    }
}
