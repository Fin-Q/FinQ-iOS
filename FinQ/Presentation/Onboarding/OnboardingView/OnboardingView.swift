//
//  OnboardingView.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>

    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
    var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)) {
            interestSelectionContent
        } destination: { store in
            switch store.case {
            case let .characterGuide(store):
                CharacterGuideView(store: store)
            }
        }
    }

    private var interestSelectionContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("관심 있는 주제를\n선택해주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 64)
            
            Text("최대 2개까지 선택할 수 있어요")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
                .padding(.top, 24)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(OnboardingFeature.Topic.allCases) { topic in
                    topicButton(topic)
                }
            }
            .padding(.top, 44)
            
            Spacer(minLength: 32)
            
            Button {
                HapticManager.selection()
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isNextButtonEnabled)
            .accessibilityIdentifier("onboarding.next")
            .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func topicButton(_ topic: OnboardingFeature.Topic) -> some View {
        Button {
            HapticManager.selection()
            store.send(.topicTapped(topic))
        } label: {
            Text(topic.title)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
        }
        .buttonStyle(.customOutline(isSelected: store.selectedTopics.contains(topic)))
        .frame(height: 60)
        .disabled(store.state.isTopicSelectionDisabled(topic))
    }
}

#Preview("선택 전") {
    AppView(store: .init(initialState: AppFeature.State(route: .onboarding), reducer: { AppFeature() }))
}

#Preview("2개 선택") {
    AppView(store: .init(initialState: AppFeature.State(route: .onboarding, onboarding: OnboardingFeature.State(selectedTopics: [.salaryAndSaving, .taxSaving])), reducer: { AppFeature() }))
}
