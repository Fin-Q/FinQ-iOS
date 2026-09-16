//
//  KnowledgeMapView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct KnowledgeMapView: View {
    @Bindable var store: StoreOf<KnowledgeMapFeature>
    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)) {
            knowledgeMapContent()
        } destination: { store in
            switch store.case {
            case let .mapDetail(store):
                MapDetailView(store: store)
            case let .advancedQuizMain(store):
                AdvancedQuizMainView(store: store)
            case let .advancedQuizIntro(store):
                AdvancedQuizIntroView(store: store)
            case let .advancedQuizQuestion(store):
                AdvancedQuizQuestionView(store: store)
            case let .advancedQuizAnswerResult(store):
                AdvancedQuizAnswerResultView(store: store)
            case let .advancedQuizCompletionSummary(store):
                AdvancedQuizCompletionSummaryView(store: store)
            case let .advancedQuizCompletion(store):
                AdvancedQuizCompletionView(store: store)
            }
        }
    }
    
    private func knowledgeMapContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("금융 지식맵")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.top, 60)
                .padding(.horizontal, 16)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(store.categories) { category in
                        Button {
                            HapticManager.selection()
                            store.send(.categoryTapped(category))
                        } label: {
                            categoryCard(category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.bottom, 72)
        .background(Color.brandWhite.ignoresSafeArea())
        .task { store.send(.onAppear) }
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
                ZStack {
                    ProgressView()
                        .controlSize(.large)
                        .tint(AppDesign.Colors.progress)
                        .padding(24)
                }
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            HapticManager.selection()
            store.send(.alertOKButtonTapped)
        })
    }

    private func categoryCard(_ category: KnowledgeMapCategory) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(category.topic.cardBackgroundColor)

            GeometryReader { proxy in
                Image(category.topic.cardImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(String(format: "%02d", category.categoryID))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.brandGray300)

                Spacer(minLength: 0)

                Text("\(category.completedContentCount)/\(category.totalContentCount)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(category.topic.supportingTextColor)
                    .padding(.horizontal, 14)
                    .frame(height: 28)
                    .background(category.topic.progressBackgroundColor, in: Capsule())
                    .overlay { Capsule().stroke(category.topic.progressBorderColor, lineWidth: 1) }

                Text(category.categoryName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(category.topic.primaryTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.top, 16)

                Text(category.topic.knowledgeMapDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(category.topic.supportingTextColor)
                    .lineSpacing(3)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(16)
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(Color.brandGray300.opacity(0.35), lineWidth: 1) }
    }
}

private extension InterestTopic {
    var cardBackgroundColor: Color { isDarkCard ? Color(red: 0.04, green: 0.07, blue: 0.11) : Color(red: 0.96, green: 0.98, blue: 1) }
    var primaryTextColor: Color { isDarkCard ? Color.brandWhite : Color.brandBlack }
    var supportingTextColor: Color { isDarkCard ? Color.brandGray300 : Color.brandBlack }
    var progressBackgroundColor: Color { isDarkCard ? Color.clear : Color.brandWhite }
    var progressBorderColor: Color { isDarkCard ? Color.brandGray400 : Color.brandLightGray }
}

#Preview {
    KnowledgeMapView(store: .init(initialState: KnowledgeMapFeature.State(categories: [
        KnowledgeMapCategory(categoryID: 1, topic: .salaryAndSaving, categoryName: "월급관리·저축", completedContentCount: 2, totalContentCount: 5, progressRate: 40, categoryCompleted: false),
        KnowledgeMapCategory(categoryID: 2, topic: .investmentBasics, categoryName: "투자기초", completedContentCount: 2, totalContentCount: 5, progressRate: 40, categoryCompleted: false),
        KnowledgeMapCategory(categoryID: 3, topic: .stocksAndETF, categoryName: "주식·ETF", completedContentCount: 2, totalContentCount: 5, progressRate: 40, categoryCompleted: false),
        KnowledgeMapCategory(categoryID: 4, topic: .taxSaving, categoryName: "세금·절세 계좌", completedContentCount: 2, totalContentCount: 5, progressRate: 40, categoryCompleted: false)
    ]), reducer: {
        KnowledgeMapFeature()
    }))
}
