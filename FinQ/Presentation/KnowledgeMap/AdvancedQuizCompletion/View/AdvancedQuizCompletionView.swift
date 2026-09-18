//
//  AdvancedQuizCompletionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AdvancedQuizCompletionView: View {
    let store: StoreOf<AdvancedQuizCompletionFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("학습을 완료했어요!")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 60)

            Image(.advancedQuizDone)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .padding(.top, 36)

            Spacer(minLength: 24)

            if let categoryResult = store.categoryResult {
                VStack(spacing: 12) {
                    if categoryResult.levelUp {
                        levelUpMessage(categoryResult)
                    }

                    xpCard(categoryResult)
                }
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .background(Color.brandWhite.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                HapticManager.selection()
                store.send(.completeButtonTapped)
            } label: {
                Text("완료")
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

    private func xpCard(_ categoryResult: AdvancedQuizCategoryResult) -> some View {
        HStack(spacing: 8) {
            Image(.xp)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 24, height: 24)

            Text("획득 XP")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brandDarkGray)

            Spacer(minLength: 0)

            Text("\(categoryResult.earnedXP)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.brandDarkGray)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, minHeight: 62)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 12))
    }

    private func levelUpMessage(_ categoryResult: AdvancedQuizCategoryResult) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                if let newLevel = categoryResult.newLevel {
                    Text("축하합니다! Lv.\(newLevel)을 달성했어요🎉")
                } else {
                    Text("축하합니다! 레벨업을 달성했어요🎉")
                }

                Text("금융 지식이 차곡차곡 쌓이고 있어요!")
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(Color.brandGray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))

            Image(.polygon)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.brandLightGray)
                .frame(width: 25, height: 14)
        }
    }
}
