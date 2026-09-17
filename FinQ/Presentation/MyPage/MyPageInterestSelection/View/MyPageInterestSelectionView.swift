//
//  MyPageInterestSelectionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MyPageInterestSelectionView: View {
    let store: StoreOf<MyPageInterestSelectionFeature>

    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("관심 있는 주제를 선택해주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 48)

            Text("최대 2개까지 선택할 수 있어요.")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
                .padding(.top, 24)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(InterestTopic.allCases) { topic in
                    topicButton(topic)
                }
            }
            .padding(.top, 44)

            Spacer(minLength: 32)

            Button {
                HapticManager.selection()
                store.send(.completeButtonTapped)
            } label: {
                Text("완료")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isCompleteButtonEnabled)
            .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .background(Color.brandWhite.ignoresSafeArea())
        .allowsHitTesting(!store.isSaving)
        .overlay {
            if store.isSaving {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", coversEntireScreen: true, onConfirm: {
            HapticManager.selection()
            store.send(.alertOKButtonTapped)
        })
    }

    private func topicButton(_ topic: InterestTopic) -> some View {
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

#Preview {
    NavigationStack {
        MyPageInterestSelectionView(store: Store(initialState: MyPageInterestSelectionFeature.State(selectedTopics: [.salaryAndSaving, .taxSaving])) {
            EmptyReducer()
        })
    }
}
