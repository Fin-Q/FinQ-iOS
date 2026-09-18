//
//  MyPageNicknameEditView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import UIKit
import ComposableArchitecture

struct MyPageNicknameEditView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<MyPageNicknameEditFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            Text("수정 닉네임을 입력해 주세요")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 40)

            VStack(alignment: .leading, spacing: 8) {
                CustomUnderlineTextFieldView(title: "닉네임 입력", text: Binding(get: { store.nickname }, set: { store.send(.nicknameChanged($0)) }), onClearTapped: {
                    store.send(.clearButtonTapped)
                })

                Text("2~7자·한글·영문·숫자·중간 공백만 허용")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(store.showsNicknameValidationError ? Color.brandRed : Color.brandGray)
            }
            .padding(.top, 40)

            Spacer(minLength: 32)

            Button {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                HapticManager.selection()
                store.send(.completeButtonTapped)
            } label: {
                Text("완료")
            }
            .buttonStyle(.customDefault)
            .disabled(!store.isCompleteButtonEnabled)
            .padding(.bottom, 44)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
        .allowsHitTesting(!store.isSaving)
        .overlay {
            if store.isSaving {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", coversEntireScreen: true, onConfirm: {
            store.send(.alertOKButtonTapped)
        })
    }

    private var backButton: some View {
        Button {
            HapticManager.selection()
            dismiss()
        } label: {
            Image(.chevronLeft)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundStyle(Color.brandGray300)
                .frame(width: 44, height: 44, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("뒤로가기")
    }
}

#Preview {
    MyPageNicknameEditView(store: Store(initialState: MyPageNicknameEditFeature.State()) {
        EmptyReducer()
    })
}
