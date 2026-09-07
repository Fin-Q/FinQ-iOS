//
//  FindPasswordView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import ComposableArchitecture

struct FindPasswordView: View {
    let store: StoreOf<FindPasswordFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("가입했던 이메일 주소를\n입력해 주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .padding(.top, 24)
                .padding(.bottom, 40)
            
            CustomUnderlineTextFieldView(
                title: "이메일",
                text: Binding(
                    get: { store.email },
                    set: { store.send(.emailChanged($0)) }
                ),
                onClearTapped: {
                    store.send(.emailChanged(""))
                }
            )
            
            Spacer()
            
            Button {
                HapticManager.selection()
            } label: {
                Text("인증번호 보내기")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isSendButtonEnabled)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    FindPasswordView(store: .init(initialState: FindPasswordFeature.State(), reducer: {
        FindPasswordFeature()
    }))
}
