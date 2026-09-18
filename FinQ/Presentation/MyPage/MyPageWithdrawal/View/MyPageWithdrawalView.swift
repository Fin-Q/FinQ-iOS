//
//  MyPageWithdrawalView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MyPageWithdrawalView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<MyPageWithdrawalFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            withdrawalInformation

            Spacer()

            withdrawalControls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
        .allowsHitTesting(!store.isWithdrawing)
        .overlay {
            if store.isWithdrawing {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", coversEntireScreen: true, onConfirm: {
            store.send(.alertOKButtonTapped)
        })
    }

    private var withdrawalInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FINQ")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(Color.brandBlack)

            Text("탈퇴 시 저장된 데이터는\n초기화되며 복구가 불가합니다")
                .font(AppDesign.Fonts.largeTitleSemiBold24)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .padding(.top, 20)

            Text("탈퇴하면 학습 기록·XP·스트릭이 모두 사라져요.\n같은 계정으로 다시 가입해도 되돌릴 수 없어요.")
                .font(AppDesign.Fonts.caption16)
                .foregroundStyle(Color.brandDarkGray)
                .lineSpacing(8)
                .padding(.top, 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 60)
    }

    private var withdrawalControls: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.brandGray300)
                .frame(height: 1)

            VStack(alignment: .leading, spacing: 0) {
                Button {
                    HapticManager.selection()
                    store.send(.agreementButtonTapped)
                } label: {
                    HStack(spacing: 8) {
                        Image(store.isAgreementChecked ? .mypageCheck : .mypageUncheck)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)

                        Text("위 내용을 확인했습니다")
                            .font(AppDesign.Fonts.body)
                            .foregroundStyle(store.isAgreementChecked ? Color.brandBlack : Color.brandGray)
                    }
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, 20)

                HStack(spacing: 20) {
                    Button {
                        HapticManager.selection()
                        dismiss()
                    } label: {
                        Text("취소하기")
                            .font(AppDesign.Fonts.buttonTitle18)
                            .foregroundStyle(Color.brandDarkGray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                        HapticManager.selection()
                        store.send(.withdrawalButtonTapped)
                    } label: {
                        Text("탈퇴하기")
                            .font(AppDesign.Fonts.buttonTitle18)
                            .foregroundStyle(store.isWithdrawalButtonEnabled ? Color.brandRed : Color.brandGray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.brandWhite)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(store.isWithdrawalButtonEnabled ? Color.brandRed : Color.brandGray300, lineWidth: 1.5)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .disabled(!store.isWithdrawalButtonEnabled)
                }
                .padding(.top, 20)
                .padding(.bottom, 44)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MyPageWithdrawalView(store: Store(initialState: MyPageWithdrawalFeature.State()) {
        EmptyReducer()
    })
}
