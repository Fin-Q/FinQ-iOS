//
//  ContentLearningView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ContentLearningView: View {
    let store: StoreOf<ContentLearningFeature>

    var body: some View {
        Group {
            switch store.phase {
            case .learning:
                if store.currentQuestion != nil {
                    ContentLearningQuestionView(store: store)
                } else {
                    ContentLearningBodyView(store: store)
                }
            case .answerResult:
                ContentLearningAnswerResultView(store: store)
            }
        }
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .allowsHitTesting(!store.isLoading && !store.isSubmittingAnswer)
        .overlay {
            if store.isLoading || store.isSubmittingAnswer {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
                    .padding(24)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", coversEntireScreen: true, onConfirm: {
            HapticManager.selection()
            store.send(.alertOKButtonTapped)
        })
        .task { store.send(.task) }
    }
}
