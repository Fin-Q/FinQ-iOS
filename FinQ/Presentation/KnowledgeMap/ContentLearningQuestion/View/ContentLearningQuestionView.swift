//
//  ContentLearningQuestionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ContentLearningQuestionView: View {
    let store: StoreOf<ContentLearningFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ContentLearningHeader()

            ScrollView {
                if let question = store.currentQuestion {
                    questionBlock(question)
                        .padding(.horizontal, 16)
                        .padding(.top, 30)
                        .padding(.bottom, 24)
                }
            }
            .id(store.currentBlockIndex)
            .scrollIndicators(.hidden)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ContentLearningNavigationButtons(isEnabled: store.isNextButtonEnabled, onNext: { store.send(.nextButtonTapped) })
        }
    }

    private func questionBlock(_ question: LearningQuestionBlock) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(question.questionBody)
                .font(AppDesign.Fonts.largeTitleSemiBold24)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            if question.isOX {
                HStack(spacing: 16) {
                    ForEach(question.options) { option in
                        oxOptionButton(option)
                    }
                }
                .padding(.top, 40)
            } else {
                LazyVStack(spacing: 24) {
                    ForEach(question.options) { option in
                        choiceOptionButton(option)
                    }
                }
                .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func oxOptionButton(_ option: LearningQuestionOption) -> some View {
        let isSelected = store.selectedOptionID == option.optionID
        let selectedColor = option.optionID.uppercased() == "X" ? Color.brandRed : Color.brandBlue

        return Button {
            HapticManager.selection()
            store.send(.optionTapped(option.optionID))
        } label: {
            VStack(spacing: 12) {
                ContentLearningAnswerIcon(isCircle: option.optionID.uppercased() == "O", color: isSelected ? selectedColor : Color.brandGray300, size: 40, lineWidth: 6)

                Text(option.optionText)
                    .font(AppDesign.Fonts.subTitle16)
                    .foregroundStyle(isSelected ? selectedColor : Color.brandGray)
            }
            .frame(maxWidth: .infinity, minHeight: 108)
            .background(isSelected ? Color.brandWhite : Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16).strokeBorder(isSelected ? selectedColor : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func choiceOptionButton(_ option: LearningQuestionOption) -> some View {
        let isSelected = store.selectedOptionID == option.optionID

        return Button {
            HapticManager.selection()
            store.send(.optionTapped(option.optionID))
        } label: {
            Text(option.optionText)
                .font(AppDesign.Fonts.buttonTitle16SemiBold)
                .foregroundStyle(isSelected ? Color.brandBlack : Color.brandGray)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16).strokeBorder(isSelected ? Color.brandBlue : Color.brandGray300, lineWidth: isSelected ? 2 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
