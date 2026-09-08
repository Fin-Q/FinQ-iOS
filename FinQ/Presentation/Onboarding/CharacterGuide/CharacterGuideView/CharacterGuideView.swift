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

            Rectangle()
                .fill(AppDesign.Colors.buttonBGDisabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(true)
                .padding(.top, 44)

            Button {
                HapticManager.selection()
                store.send(.startButtonTapped)
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.customDefault)
            .padding(.top, 40)
            .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        CharacterGuideView(store: .init(initialState: CharacterGuideFeature.State(), reducer: { CharacterGuideFeature() }))
    }
}
