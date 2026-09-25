//
//  ContentLearningCompletionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ContentLearningCompletionView: View {
    let store: StoreOf<ContentLearningCompletionFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("학습을 완료했어요!")
                .font(AppDesign.Fonts.largeTitleSemiBold24)
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 74)

            Image(.advancedQuizDone)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .padding(.top, 36)

            Spacer(minLength: 24)
            
            if store.isGuestMode {
                guestLoginCard()
                    .padding(.bottom, 24)
            } else if let result = store.completionResult {
                VStack(spacing: 12) {
                    if result.levelUp {
                        levelUpMessage(result)
                    }

                    xpCard(result)
                }
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ContentLearningNavigationButtons(title: "완료", onNext: { store.send(.completeButtonTapped) })
        }
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func xpCard(_ result: ContentCompletionResult) -> some View {
        HStack(spacing: 8) {
            Image(.xp)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 24, height: 24)

            Text("획득 XP")
                .font(AppDesign.Fonts.subTitle16)
                .foregroundStyle(Color.brandDarkGray)

            Spacer(minLength: 0)

            Text("\(result.earnedXP)")
                .font(AppDesign.Fonts.body18SemiBold)
                .foregroundStyle(Color.brandDarkGray)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, minHeight: 62)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 12))
    }

    private func levelUpMessage(_ result: ContentCompletionResult) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                if let newLevel = result.newLevel {
                    Text("축하합니다! Lv.\(newLevel)을 달성했어요🎉")
                } else {
                    Text("축하합니다! 레벨업을 달성했어요🎉")
                }

                Text("금융 지식이 차곡차곡 쌓이고 있어요!")
            }
            .font(AppDesign.Fonts.caption)
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
    
    private func guestLoginCard() -> some View {
        HStack(spacing: 12) {
            Text("로그인하고 성장 기록을 쌓기")
                .font(AppDesign.Fonts.body16SemiBold)
                .foregroundStyle(Color.brandBlack)
            
            Spacer(minLength: 0)
            
            Button {
                HapticManager.selection()
                store.send(.guestLoginButtonTapped)
            } label: {
                Text("로그인하기")
                    .font(AppDesign.Fonts.buttonTitle16SemiBold)
                    .foregroundStyle(Color.brandBlue)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(Color.brandBlue.opacity(0.1), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, minHeight: 82)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 12))
    }
}
