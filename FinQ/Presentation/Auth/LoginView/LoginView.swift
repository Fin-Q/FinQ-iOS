//
//  LoginView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("로그인 정보를\n입력해 주세요" )
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .padding(.top, 24)
                .padding(.bottom, 40)
            
            CustomUnderlineTextFieldView(
                title: "아이디 (이메일 주소)",
                text: Binding(
                    get: { store.email },
                    set: { store.send(.emailChanged($0)) }
                ),
                onClearTapped: {
                    store.send(.emailChanged(""))
                }
            )
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .padding(.bottom, 40)
            
            CustomUnderlineSecureFieldView(
                title: "비밀번호",
                text: Binding(
                    get: { store.password },
                    set: { store.send(.passwordChanged($0)) }
                ),
                onClearTapped: {
                    store.send(.passwordChanged(""))
                }
            )
            .textContentType(.password)
            
            Spacer()
            
            Button {
                HapticManager.selection()
            } label: {
                Text("로그인")
            }
            .disabled(!store.isLoginButtonEnabled)
            .buttonStyle(.customDefault)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
        .onDidAppear {
            var transaction = Transaction(animation: nil)
            transaction.disablesAnimations = true
            
            withTransaction(transaction) {
                _ = store.send(.didAppear)
            }
        }
    }
}

#Preview {
    LoginView(store: .init(initialState: LoginFeature.State(), reducer: {
        LoginFeature()
    }))
}
