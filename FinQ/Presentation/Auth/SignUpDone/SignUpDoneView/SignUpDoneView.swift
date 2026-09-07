//
//  SignUpDoneView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import ComposableArchitecture

struct SignUpDoneView: View {
    let store: StoreOf<SignUpDoneFeature>
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 121)
            
            Image(.checkCircle)
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.bottom, 36)
            
            Text("회원 가입이 완료됐어요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.bottom, 12)
            
            Text("이제 궁금했던 금융 질문부터 시작해봐요")
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.caption)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.customDefault)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignUpDoneView(store: .init(initialState: SignUpDoneFeature.State(), reducer: {
        SignUpDoneFeature()
    }))
}
