//
//  AdvancedQuizAnswerResultView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AdvancedQuizAnswerResultView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<AdvancedQuizAnswerResultFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    statusSection

                    Text(store.question.questionBody)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 44)

                    answerCard
                        .padding(.top, 24)

                    explanationCard
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
                store.send(.primaryButtonTapped)
            } label: {
                Text(isCorrect ? "다음" : "재도전")
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

    private var statusSection: some View {
        VStack(spacing: 12) {
            if isCorrect {
                Image(.checkCircle)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } else {
                Image(.xCircle)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }

            Text(isCorrect ? "정답이에요" : "오답이에요")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brandDarkGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 30)
    }

    private var answerCard: some View {
        HStack(spacing: 8) {
            if isCorrect {
                Image(.circle)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            } else {
                Image(.x)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }

            Text(answerDescription)
                .font(AppDesign.Fonts.caption16)
                .foregroundStyle(Color.brandDarkGray)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isCorrect ? Color.brandBlue : Color.brandRed, lineWidth: 2)
        }
    }

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("해설")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.brandBlack)

            Text(store.result.explanation)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.brandDarkGray)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
    }

    private var isCorrect: Bool { store.presentation == .correct }

    private var answerDescription: String {
        if isCorrect {
            return store.correctOption?.optionText ?? ""
        }

        if let correctOptionNumber = store.correctOptionNumber {
            return "오답! 정답은 \(correctOptionNumber)번이에요"
        }

        return "오답이에요"
    }
}
