//
//  ContentLearningAnswerResultView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ContentLearningAnswerResultView: View {
    let store: StoreOf<ContentLearningFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ContentLearningHeader()

            ScrollView {
                if let question = store.currentQuestion, let result = store.answerResult {
                    answerResultContent(question: question, result: result)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
            }
            .scrollIndicators(.hidden)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ContentLearningNavigationButtons(title: store.answerResult?.correct == true ? "다음" : "재도전", onNext: { store.send(.answerResultButtonTapped) })
        }
    }

    private func answerResultContent(question: LearningQuestionBlock, result: ContentAnswerResult) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            answerStatus(result.correct)

            Text(question.questionBody)
                .font(AppDesign.Fonts.title20SemiBold)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)

            answerCard(question: question, result: result)
                .padding(.top, 24)

            VStack(alignment: .leading, spacing: 16) {
                Text("해설")
                    .font(AppDesign.Fonts.body18SemiBold)
                    .foregroundStyle(Color.brandBlack)

                ContentLearningText(text: result.explanation)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func answerStatus(_ isCorrect: Bool) -> some View {
        VStack(spacing: 12) {
            Image(isCorrect ? .checkCircle : .xCircle)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text(isCorrect ? "정답이에요" : "오답이에요")
                .font(AppDesign.Fonts.subTitle16)
                .foregroundStyle(Color.brandDarkGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 30)
    }

    private func answerCard(question: LearningQuestionBlock, result: ContentAnswerResult) -> some View {
        let isCircle = result.correct && (!question.isOX || result.correctOptionID.uppercased() == "O")

        return HStack(spacing: 12) {
            ContentLearningAnswerIcon(isCircle: isCircle, color: result.correct ? Color.brandBlue : Color.brandRed, size: result.correct ? 18 : 16, lineWidth: 2)

            Text(answerDescription(question: question, result: result))
                .font(AppDesign.Fonts.body16Redular)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16).strokeBorder(result.correct ? Color.brandBlue : Color.brandRed, lineWidth: 2)
        }
    }

    private func answerDescription(question: LearningQuestionBlock, result: ContentAnswerResult) -> String {
        let correctOption = question.options.first(where: { $0.optionID == result.correctOptionID })
        guard !result.correct else { return correctOption?.optionText ?? "" }

        if question.isOX { return "오답! 정답은 \(correctOption?.optionText ?? result.correctOptionID)에요" }
        guard let correctOptionIndex = question.options.firstIndex(where: { $0.optionID == result.correctOptionID }) else { return "오답이에요" }
        return "오답! 정답은 \(correctOptionIndex + 1)번이에요"
    }
}
