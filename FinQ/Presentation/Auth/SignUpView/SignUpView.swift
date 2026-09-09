//
//  SignUpView.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct SignUpView: View {
    let store: StoreOf<SignUpFeature>
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissKeyboard()
                }
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onEnded { value in
                            let velocity = value.velocity
                            
                            guard velocity.height > 0,
                                  velocity.height > abs(velocity.width) else {
                                return
                            }
                            
                            dismissKeyboard()
                        }
                )
            
            VStack(alignment: .leading) {
                Text("이메일 주소와\n비밀번호를 입력하세요")
                    .font(AppDesign.Fonts.largeTitleSemiBold)
                    .foregroundStyle(AppDesign.Colors.largeTitle)
                    .lineSpacing(8)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                
                VStack(spacing: 28) {
                    CustomUnderlineValidTextFieldView(
                        title: "이메일 주소",
                        text: Binding(
                            get: { store.email },
                            set: { store.send(.emailChanged($0)) }
                        ),
                        validationState: emailValidationState,
                        onEditingEnded: {
                            store.send(.emailEditingEnded)
                        }
                    )
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    
                    CustomUnderlineValidSecureFieldView(
                        title: "비밀번호 (영문+숫자+특수문자 8자리 이상)",
                        text: Binding(
                            get: { store.password },
                            set: { store.send(.passwordChanged($0)) }
                        ),
                        validationState: passwordValidationState,
                        onEditingEnded: {
                            store.send(.passwordEditingEnded)
                        }
                    )
                    
                    CustomUnderlineValidSecureFieldView(
                        title: "비밀번호 확인",
                        text: Binding(
                            get: { store.passwordCheck },
                            set: { store.send(.passwordCheckChanged($0)) }
                        ),
                        validationState: passwordCheckValidationState,
                        onEditingEnded: {
                            store.send(.passwordCheckEditingEnded)
                        }
                    )
                }
                
                Spacer()
                
                Button {
                    dismissKeyboard()
                    HapticManager.selection()
                    store.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .buttonStyle(.customDefault)
                .disabled(!store.isFormValid || store.isLoading)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 16)
        }
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
            isPresented: Binding(
                get: { store.signUpErrorMessage != nil },
                set: { _ in }
            ),
            title: "알림",
            message: store.signUpErrorMessage ?? "",
            onConfirm: {
                HapticManager.selection()
                store.send(.alertOKButtonTapped)
            }
        )
    }

    private var emailValidationState: CustomUnderlineValidTextFieldView.ValidationState {
        guard store.shouldShowEmailValidation,
              !store.email.isEmpty else {
            return .idle
        }

        return store.isEmailValid
        ? .valid
        : .invalid(message: "올바른 이메일 형식으로 입력해 주세요.")
    }
    
    private var passwordValidationState: CustomUnderlineValidSecureFieldView.ValidationState {
        guard store.shouldShowPasswordValidation,
              !store.password.isEmpty else {
            return .idle
        }
        
        return store.isPasswordValid
        ? .valid
        : .invalid(message: "8자 이상 영문 숫자 특수문자 조합으로 입력해 주세요.")
    }
    
    private var passwordCheckValidationState: CustomUnderlineValidSecureFieldView.ValidationState {
        guard store.shouldShowPasswordCheckValidation else {
            return .idle
        }

        if store.isPasswordCheckValid {
            return .valid
        }
        
        if store.isPasswordCheckMismatch {
            return .invalid(message: "비밀번호가 일치하지 않습니다.")
        }
        
        return .idle
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView(store: .init(initialState: SignUpFeature.State(), reducer: {
        SignUpFeature()
    }))
}
