//
//  PasswordResetDoneView.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI
import ComposableArchitecture

struct PasswordResetDoneView: View {
    let store: StoreOf<PasswordResetDoneFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("비밀번호 재설정이\n완료되었습니다")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 65)

            Text("로그인 화면으로 돌아갈게요")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
                .padding(.top, 24)

            Spacer()

            Button {
                HapticManager.selection()
                store.send(.navigateLoginButtonTapped)
            } label: {
                Text("로그인하기")
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
        PasswordResetDoneView(store: .init(initialState: PasswordResetDoneFeature.State(), reducer: { PasswordResetDoneFeature() }))
    }
}
