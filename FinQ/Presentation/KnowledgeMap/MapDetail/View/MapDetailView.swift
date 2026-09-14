//
//  MapDetailView.swift
//  FinQ
//
//  Created by 권대윤 on 9/13/26.
//

import Foundation
import SwiftUI
import UIKit
import ComposableArchitecture

struct MapDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<MapDetailFeature>
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    heroSection
                    learningListSection
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(red: 0.96, green: 0.97, blue: 0.98).ignoresSafeArea())
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(!store.isLoading)
            
            backButton
                .padding(.leading, 16)
        }
        .background(InteractivePopGestureEnabler())
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.onAppear) }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.buttonBG)
                    .padding(24)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            HapticManager.selection()
            store.send(.alertOKButtonTapped)
        })
        .customOneButtonAlert(
            isPresented: Binding(get: { store.isPremiumAlertPresented }, set: { _ in }),
            title: "프리미엄 문제 제목, 곧 만나요",
            message: "프리미엄 개념은\n지금 열심히 준비 중이에요.",
            buttonTitle: "확인했어요",
            onConfirm: {
                HapticManager.selection()
                store.send(.premiumAlertOKButtonTapped)
            }
        )
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
    
    private var heroSection: some View {
        Image(.mapDetailCharacter)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topLeading) {
                heroInformation
                    .padding(.top, 112)
                    .padding(.horizontal, 16)
            }
            .overlay(alignment: .bottom) {
                challengeCard
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
    }
    
    private var heroInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(categoryName)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Text(store.category.topic.knowledgeMapDescription.replacingOccurrences(of: "\n", with: " "))
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.brandDarkGray)
                .padding(.top, 12)
            
            HStack(spacing: 4) {
                Text("학습 완료")
                    .foregroundStyle(Color.brandDarkGray)
                
                Text("\(completedContentCount)/\(totalContentCount)")
                    .foregroundStyle(Color.brandBlue)
            }
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 12)
            .frame(height: 28)
            .background(Color.brandWhite, in: Capsule())
            .padding(.top, 16)
        }
    }
    
    private var challengeCard: some View {
        HStack(spacing: 12) {
            Image(.trophy)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("최종보스 도전")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                Text("심화퀴즈 3문제 도전")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.brandGray)
            }
            
            Spacer(minLength: 8)
            
            Button {
                store.send(.challengeButtonTapped)
            } label: {
                Text("도전하기")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.brandBlue)
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .background(Color.brandBlue.opacity(0.12), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(height: 84)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var learningListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("학습 목록")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 10)
            
            if let detail = store.detail {
                ForEach(detail.contents) { content in
                    Button {
                        store.send(.contentCardTapped(content.contentID))
                    } label: {
                        learningCard(content)
                    }
                    .buttonStyle(.plain)
                }
                
                ForEach(detail.premiumContents) { content in
                    Button {
                        store.send(.premiumContentTapped(content))
                    } label: {
                        premiumCard(content)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 36)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
    }
    
    private func learningCard(_ content: KnowledgeMapContent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            let normalizedDescription = content.description
                .replacingOccurrences(of: "\\n", with: "\n")
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .joined(separator: " ")

            let attributedDescription = (try? AttributedString(markdown: normalizedDescription, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(normalizedDescription)

            Text(String(format: "%02d", content.order))
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brandGray)
            
            Text(content.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.leading)
                .padding(.top, 15)
            
            completionStatus(content.completionStatus)
                .padding(.top, 15)

            Spacer()
                .frame(height: 24)

            keywordCapsules(content.keyword)
            
            Text(attributedDescription)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.brandGray)
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.top, 25)
        }
        .padding(24)
        .frame(maxWidth: 370, minHeight: 307, maxHeight: 307, alignment: .topLeading)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func premiumCard(_ content: KnowledgeMapPremiumContent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(.premiumStar)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 15, height: 15)
                Text("Premium")
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.orange)
            .padding(.horizontal, 10)
            .frame(height: 28)
            .overlay { Capsule().stroke(Color.orange, lineWidth: 1) }
            
            Text(content.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.leading)
                .padding(.top, 14)

            keywordCapsules(content.keyword)
                .padding(.top, 24)
        }
        .padding(24)
        .frame(maxWidth: 370, minHeight: 307, maxHeight: 307, alignment: .topLeading)
        .background {
            GeometryReader { proxy in
                Image(.premiumBack).resizable().scaledToFill().frame(width: proxy.size.width, height: proxy.size.height, alignment: .top).clipped()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func keywordCapsules(_ keywords: [String]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(keywords.enumerated()), id: \.offset) { _, keyword in
                    Text("#\(keyword)")
                        .font(AppDesign.Fonts.body)
                        .foregroundStyle(Color.brandDarkGray)
                        .padding(.horizontal, 12)
                        .frame(height: 36)
                        .background {
                            Capsule()
                                .strokeBorder(Color.brandGray300, lineWidth: 1)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func completionStatus(_ status: KnowledgeMapCompletionStatus) -> some View {
        if status.isCompleted {
            HStack(spacing: 6) {
                Image(.checkCircle)
                Text("학습 완료")
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Color.brandBlue)
        } else {
            Text("학습 전")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.brandGray)
        }
    }
    
    private var categoryName: String { store.detail?.categoryName ?? store.category.categoryName }
    private var completedContentCount: Int { store.detail?.completedContentCount ?? store.category.completedContentCount }
    private var totalContentCount: Int { store.detail?.totalContentCount ?? store.category.totalContentCount }
}

private struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller {
        return Controller()
    }
    
    func updateUIViewController(_ uiViewController: Controller, context: Context) { }
    
    final class Controller: UIViewController {
        private weak var popGestureRecognizer: UIGestureRecognizer?
        private var originalDelegate: (any UIGestureRecognizerDelegate)?
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            guard let navigationController, navigationController.viewControllers.count > 1, let gestureRecognizer = navigationController.interactivePopGestureRecognizer else { return }
            popGestureRecognizer = gestureRecognizer
            originalDelegate = gestureRecognizer.delegate
            gestureRecognizer.delegate = nil
            gestureRecognizer.isEnabled = true
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            guard let popGestureRecognizer, popGestureRecognizer.delegate == nil else { return }
            popGestureRecognizer.delegate = originalDelegate
        }
    }
}

#Preview {
    MapDetailView(store: Store(initialState: MapDetailFeature.State(category: KnowledgeMapCategory(categoryID: 4, topic: .taxSaving, categoryName: "세금·절세계좌", completedContentCount: 2, totalContentCount: 9, progressRate: 22, categoryCompleted: false), detail: KnowledgeMapCategoryDetail(categoryID: 4, topic: .taxSaving, categoryName: "세금·절세계좌", completedContentCount: 2, totalContentCount: 9, progressRate: 22, categoryCompleted: false, advancedQuizStatus: .incomplete, contents: [KnowledgeMapContent(contentID: 18, contentCode: "TAX-01", keyword: ["금융소득"], title: "금융소득", description: "이자, 배당 등 금융소득의 개념을 알아보세요.", completionStatus: .completed, order: 1), KnowledgeMapContent(contentID: 19, contentCode: "TAX-02", keyword: ["이자", "배당소득세"], title: "이자·배당소득세", description: "세전과 세후의 차이를 이해해보세요.", completionStatus: .incomplete, order: 2)], premiumContents: [KnowledgeMapPremiumContent(contentID: 30, keyword: ["세금용어", "절세기초"], title: "세금용어·절세기초")])), reducer: {
        MapDetailFeature()
    }))
}
