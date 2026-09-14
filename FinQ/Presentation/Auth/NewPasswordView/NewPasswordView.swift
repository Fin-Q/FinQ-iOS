//
//  NewPasswordView.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct NewPasswordView: View {
    let store: StoreOf<NewPasswordFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("새로운 비밀번호를\n입력해 주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.top, 24)
            
            CustomUnderlineValidSecureFieldView(
                title: "비밀번호 (영문+숫자+특수문자 8자리 이상)",
                text: Binding(get: { store.password }, set: { store.send(.passwordChanged($0)) }),
                validationState: passwordValidationState,
                onEditingEnded: { store.send(.passwordEditingEnded) }
            )
            .padding(.top, 40)
            
            CustomUnderlineValidSecureFieldView(
                title: "비밀번호 확인",
                text: Binding(get: { store.passwordCheck }, set: { store.send(.passwordCheckChanged($0)) }),
                validationState: passwordCheckValidationState,
                onEditingEnded: { store.send(.passwordCheckEditingEnded) }
            )
            .padding(.top, 30)
            
            Spacer()
            
            Button {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                HapticManager.selection()
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isFormValid)
            .padding(.bottom, 16)

        }
        .padding(.horizontal,16)
    }

    private var passwordValidationState: CustomUnderlineValidSecureFieldView.ValidationState {
        guard store.shouldShowPasswordValidation, !store.password.isEmpty else { return .idle }
        return store.isPasswordValid ? .valid : .invalid(message: "8자 이상 영문 숫자 특수문자 조합으로 입력해 주세요.")
    }

    private var passwordCheckValidationState: CustomUnderlineValidSecureFieldView.ValidationState {
        guard store.shouldShowPasswordCheckValidation else { return .idle }
        if store.isPasswordCheckValid { return .valid }
        if store.isPasswordCheckMismatch { return .invalid(message: "비밀번호가 일치하지 않습니다.") }
        return .idle
    }
}

#Preview {
    NewPasswordView(store: .init(initialState: NewPasswordFeature.State(), reducer: {
        NewPasswordFeature()
    }))
}
