//
//  FindPasswordView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import UIKit
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
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            
            Spacer()
            
            Button {
                dismissKeyboard()
                HapticManager.selection()
                store.send(.sendButtonTapped)
            } label: {
                Text("인증번호 보내기")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isSendButtonEnabled)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()

                    ProgressView()
                        .controlSize(.large)
                        .tint(AppDesign.Colors.progress)
                        .padding(24)
                }
            }
        }
        .customOneButtonAlert(
            isPresented: Binding(get: { store.sendErrorMessage != nil }, set: { _ in }),
            title: "알림",
            message: store.sendErrorMessage ?? "",
            onConfirm: {
                HapticManager.selection()
                store.send(.alertOKButtonTapped)
            }
        )
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    FindPasswordView(store: .init(initialState: FindPasswordFeature.State(), reducer: {
        FindPasswordFeature()
    }))
}
