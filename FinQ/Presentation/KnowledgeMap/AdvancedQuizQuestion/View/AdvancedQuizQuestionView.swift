//
//  AdvancedQuizQuestionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AdvancedQuizQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<AdvancedQuizQuestionFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            ScrollView {
                if let question = store.question {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(question.questionBody)
                            .font(AppDesign.Fonts.largeTitleSemiBold24)
                            .foregroundStyle(Color.brandBlack)
                            .lineSpacing(8)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 24)

                        LazyVStack(spacing: 24) {
                            ForEach(question.options) { option in
                                optionButton(option)
                            }
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 24)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
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
            .disabled(!store.isNextButtonEnabled)
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
            .background(Color.brandWhite)
        }
        .enableInteractivePopGesture()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .allowsHitTesting(!store.isSubmittingAnswer)
        .overlay {
            if store.isSubmittingAnswer {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
                    .padding(24)
            }
        }
        .fullScreenCover(item: $store.scope(\.incorrectAnswer, action: \.incorrectAnswer)) { store in
            AdvancedQuizAnswerResultView(store: store)
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            HapticManager.selection()
            store.send(.alertOKButtonTapped)
        })
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

    private func optionButton(_ option: AdvancedQuizOption) -> some View {
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
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(isSelected ? Color.brandBlue : Color.brandGray300, lineWidth: isSelected ? 2 : 1)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        AdvancedQuizQuestionView(store: .init(initialState: AdvancedQuizQuestionFeature.State(quiz: AdvancedQuiz(categoryID: 1, categoryName: "월급관리·저축", rewardXP: 30, introTitle: "", introDescription: "", completionTitle: "", completionDescription: "", questions: [AdvancedQuizQuestion(questionID: 1, order: 1, questionType: "SINGLE_CHOICE", questionBody: "월급은 같은데 지난달 40만 원, 이번 달 10만 원이 남았다면 무엇을 확인해야 할까요?", options: [AdvancedQuizOption(optionID: "A", optionText: "두 달의 지출 항목과 금액이 어떻게 달라졌는지"), AdvancedQuizOption(optionID: "B", optionText: "최근 예금 금리가 얼마나 올랐는지"), AdvancedQuizOption(optionID: "C", optionText: "이번 달 투자 수익률이 얼마였는지"), AdvancedQuizOption(optionID: "D", optionText: "신용점수가 지난달보다 바뀌었는지")])])), reducer: {
            AdvancedQuizQuestionFeature()
        }))
    }
}
