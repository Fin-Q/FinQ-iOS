//
//  AdvancedQuizMainView.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import SwiftUI
import ComposableArchitecture

struct AdvancedQuizMainView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<AdvancedQuizMainFeature>

    var body: some View {
        ZStack {
            Image(.advancedQuizMainBack)
                .resizable()
                .renderingMode(.original)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)

            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 45)

                backButton

                Text("최종보스")
                    .font(AppDesign.Fonts.largeTitleSemiBold24)
                    .foregroundStyle(Color.brandBlack)
                    .padding(.top, 30)

                Text("심화퀴즈 3문제를 도전해봐요.")
                    .font(AppDesign.Fonts.subTitle16)
                    .foregroundStyle(Color.brandDarkGray)
                    .padding(.top, 12)

                Spacer(minLength: 24)

                VStack(spacing: 8) {
                    ForEach(Array(benefitDescriptions.enumerated()), id: \.offset) { _, description in
                        benefitCard(description)
                    }
                }

                Button {
                    HapticManager.selection()
                    store.send(.challengeButtonTapped)
                } label: {
                    Text("도전하기")
                }
                .buttonStyle(.customDefault)
                .disabled(store.quiz == nil)
                .padding(.top, 24)
                .padding(.bottom, 77)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
        }
        .enableInteractivePopGesture()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.onAppear) }
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
                    .padding(24)
            }
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

    private func benefitCard(_ title: String) -> some View {
        HStack(spacing: 16) {
            Image(.checkBlue)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 14, height: 24)

            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.brandDarkGray)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }

    private var benefitDescriptions: [String] {
        return [
            "이번 카테고리의 최종 관문이에요",
            "원하는 카테고리를 한 번에 클리어",
            "성공하면 30XP 획득"
        ]
    }

}

#Preview {
    AdvancedQuizMainView(store: .init(initialState: AdvancedQuizMainFeature.State(categoryID: 4, quiz: AdvancedQuiz(categoryID: 4, categoryName: "세금·절세계좌", rewardXP: 30, introTitle: "세금·절세계좌, 얼마나 이해했을까요?", introDescription: "지금까지 배운 내용을 바탕으로 여러 개념을 함께 생각하는 3문제를 풀어볼게요.\n\n확인 범위: 금융소득 / 주식·ETF 세금 / 절세계좌 / 과세이연 / ISA / 연금저축 / IRP\n\n3문제를 모두 맞히면 심화퀴즈 완료예요.", completionTitle: "세금·절세계좌 심화퀴즈 완료!", completionDescription: "", questions: [AdvancedQuizQuestion(questionID: 10, order: 1, questionType: "SINGLE_CHOICE", questionBody: "", options: []), AdvancedQuizQuestion(questionID: 11, order: 2, questionType: "SINGLE_CHOICE", questionBody: "", options: []), AdvancedQuizQuestion(questionID: 12, order: 3, questionType: "SINGLE_CHOICE", questionBody: "", options: [])])), reducer: {
        AdvancedQuizMainFeature()
    }))
}
