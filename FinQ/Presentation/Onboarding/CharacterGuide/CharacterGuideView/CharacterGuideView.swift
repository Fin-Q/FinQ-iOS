//
//  CharacterGuideView.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI
import ComposableArchitecture

struct CharacterGuideView: View {
    let store: StoreOf<CharacterGuideFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FINQ")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.top, 64)

            Text("쉽고 간편하게! 금융 공부를\n핀큐와 함께 시작해보세요!")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 28)

            Spacer()

            Button {
                HapticManager.selection()
                store.send(.startButtonTapped)
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.customDefault)
            .disabled(store.isLoading)
            .padding(.top, 40)
            .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .background(
            Image(.onboardingCharacter)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()

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
}

#Preview {
    NavigationStack {
        CharacterGuideView(store: .init(initialState: CharacterGuideFeature.State(), reducer: { CharacterGuideFeature() }))
    }
}
