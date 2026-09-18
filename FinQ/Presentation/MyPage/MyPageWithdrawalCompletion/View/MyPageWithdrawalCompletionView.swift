//
//  MyPageWithdrawalCompletionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MyPageWithdrawalCompletionView: View {
    let store: StoreOf<MyPageWithdrawalCompletionFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FINQ")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(Color.brandBlack)

            Text("탈퇴가 정상적으로\n접수되었습니다")
                .font(AppDesign.Fonts.largeTitleSemiBold24)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .padding(.top, 20)

            Text("탈퇴 신청한 날짜를 기준으로 2일~7일 정도 소요될\n수 있습니다. 지연될 경우 메일로 문의주세요.")
                .font(AppDesign.Fonts.caption16)
                .foregroundStyle(Color.brandDarkGray)
                .lineSpacing(8)
                .padding(.top, 24)

            Spacer()

            Button {
                HapticManager.selection()
                store.send(.confirmButtonTapped)
            } label: {
                Text("확인")
            }
            .buttonStyle(.customDefault)
            .padding(.bottom, 44)
        }
        .padding(.horizontal, 16)
        .padding(.top, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MyPageWithdrawalCompletionView(store: Store(initialState: MyPageWithdrawalCompletionFeature.State()) {
        EmptyReducer()
    })
}
