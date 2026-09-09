//
//  LoginView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import UIKit
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
                dismissKeyboard()
                HapticManager.selection()
                store.send(.loginButtonTapped)
            } label: {
                Text("로그인")
            }
            .disabled(!store.isLoginButtonEnabled)
            .buttonStyle(.customDefault)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
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
        .customOneButtonAlert(
            isPresented: Binding(get: { store.loginErrorMessage != nil }, set: { _ in }),
            title: "알림",
            message: store.loginErrorMessage ?? "",
            onConfirm: {
                HapticManager.selection()
                store.send(.alertOKButtonTapped)
            }
        )
        .onDidAppear {
            var transaction = Transaction(animation: nil)
            transaction.disablesAnimations = true
            
            withTransaction(transaction) {
                _ = store.send(.didAppear)
            }
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView(store: .init(initialState: LoginFeature.State(), reducer: {
        LoginFeature()
    }))
}
