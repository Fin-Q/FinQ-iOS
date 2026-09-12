//
//  EmailVerificationView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct EmailVerificationView: View {
    let store: StoreOf<EmailVerificationFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("입력하신 이메일 주소로 발송된\n인증번호를 입력해 주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .padding(.top, 24)
            
            CustomUnderlineTextFieldView(
                title: "이메일",
                text: Binding(
                    get: { store.email },
                    set: { _ in }
                ),
                showsClearButton: false
            )
            .disabled(true)
            .padding(.top, 40)
            
            CustomUnderlineTextFieldView(
                title: "인증번호",
                text: Binding(
                    get: { store.code },
                    set: { store.send(.codeChanged($0)) }
                )
            )
            .keyboardType(.numberPad)
            .padding(.top, 20)
            
            
            HStack {
                let message = switch store.verificationState {
                case .progress: store.secondsText
                case .timeout: "인증 시간이 만료되었습니다\n인증번호를 다시 요청해 주세요"
                case .error: "인증번호 발송에 실패했습니다.\n다시 시도해 주세요 "
                }
                Text(message)
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.captionInvalid)
                    .monospacedDigit()
                    .lineSpacing(2)
                
                Spacer()
                
                Button(action: {
                    dismissKeyboard()
                    HapticManager.selection()
                    store.send(.resendButtonTapped)
                }) {
                    Text(store.resendAvailableIn > 0 ? "재발송까지 \(store.resendAvailableIn)초" : "인증번호 재발송")
                        .font(AppDesign.Fonts.caption)
                        .monospacedDigit()
                        .foregroundStyle(AppDesign.Colors.caption)
                        .underline(true, color: AppDesign.Colors.caption)
                }
                .buttonStyle(.plain)
                .disabled(!store.isResendButtonEnabled)
                .opacity(store.isResendButtonEnabled ? 1 : 0.5)
            }
            .frame(height: 44)
            .padding(.top, 3)
            
            Spacer()
            
            Button {
                dismissKeyboard()
                HapticManager.selection()
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .buttonStyle(.customDefault)
            .padding(.bottom, 16)
            .disabled(!store.isNextButtonEnabled)
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
            isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }),
            title: "알림",
            message: store.errorMessage ?? "",
            onConfirm: {
                HapticManager.selection()
                store.send(.alertOKButtonTapped)
            }
        )
        .task {
            await store.send(.task).finish()
        }
        .onDisappear { store.send(.onDisappear) }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    EmailVerificationView(store: .init(initialState: EmailVerificationFeature.State(), reducer: {
        EmailVerificationFeature()
    }))
}
