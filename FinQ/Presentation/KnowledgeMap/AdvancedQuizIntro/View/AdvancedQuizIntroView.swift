//
//  AdvancedQuizIntroView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AdvancedQuizIntroView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<AdvancedQuizIntroFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(store.quiz.introTitle)
                        .font(AppDesign.Fonts.largeTitleSemiBold)
                        .foregroundStyle(Color.brandBlack)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 30)

                    Text(store.quiz.introDescription.markdownAttributedString(collapseParagraphBreaks: true))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.brandDarkGray)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 36)
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
                store.send(.startButtonTapped)
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.customDefault)
            .disabled(store.quiz.questions.isEmpty)
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
            dismiss()
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
}

#Preview {
    NavigationStack {
        AdvancedQuizIntroView(store: .init(initialState: AdvancedQuizIntroFeature.State(quiz: AdvancedQuiz(categoryID: 1, categoryName: "월급관리·저축", rewardXP: 30, introTitle: "월급관리·저축, 얼마나 이해했을까요?", introDescription: "지금까지 배운 내용을 바탕으로 서로 다른 개념을 함께 생각해보는 3개의 문제를 풀어볼게요.\\n\\n틀린 문제는 해설을 확인하고 다시 도전할 수 있어요.\\n\\n**3문제를 모두 맞히면 심화퀴즈 완료!**", completionTitle: "월급관리·저축 심화퀴즈 완료!", completionDescription: "", questions: [])), reducer: {
            AdvancedQuizIntroFeature()
        }))
    }
}
