//
//  SignUpDoneView.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI
import ComposableArchitecture

struct SignUpDoneView: View {
    let store: StoreOf<SignUpDoneFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.checkCircle)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .accessibilityHidden(true)
                .padding(.top, 160)
            
            Text("회원가입이 완료됐어요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            Text("이제 궁금했던 금융 질문부터 시작해봐요")
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.caption)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            
            Spacer(minLength: 32)
            
            Button {
                HapticManager.selection()
                store.send(.startButtonTapped)
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.customDefault)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SignUpDoneView(store: .init(initialState: SignUpDoneFeature.State(), reducer: { SignUpDoneFeature() }))
    }
}
