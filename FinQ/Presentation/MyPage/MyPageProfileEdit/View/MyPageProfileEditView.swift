//
//  MyPageProfileEditView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Kingfisher

struct MyPageProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<MyPageProfileEditFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            Button {
                HapticManager.selection()
                store.send(.profileImageButtonTapped)
            } label: {
                profileImage
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(.top, 40)

            VStack(spacing: 0) {
                if let email = store.myPage.email {
                    informationRow(title: "아이디", value: email)
                }

                nicknameRow
                interestRow
            }
            .padding(.top, 48)

            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
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

    private var profileImage: some View {
        KFImage(URL(string: store.myPage.profileImageURL))
            .placeholder {
                Circle()
                    .fill(Color.brandGray300.opacity(0.35))
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 104)
            .clipShape(Circle())
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(Color.brandWhite)
                    .frame(width: 28, height: 28)
                    .overlay {
                        Image(.pen)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 28, height: 28)
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(AppDesign.Colors.borderWhite, lineWidth: 1)
                    }
            }
    }

    private var interestRow: some View {
        Button {
            HapticManager.selection()
            store.send(.interestButtonTapped)
        } label: {
            informationRowContent(title: "관심 주제", value: store.myPage.interests.map(\.categoryName).joined(separator: " / "), showsChevron: true)
        }
        .buttonStyle(.plain)
    }

    private var nicknameRow: some View {
        Button {
            HapticManager.selection()
            store.send(.nicknameButtonTapped)
        } label: {
            informationRowContent(title: "닉네임", value: store.myPage.nickname, showsChevron: true)
        }
        .buttonStyle(.plain)
    }

    private func informationRow(title: String, value: String, showsChevron: Bool = false) -> some View {
        informationRowContent(title: title, value: value, showsChevron: showsChevron)
    }

    private func informationRowContent(title: String, value: String, showsChevron: Bool) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(AppDesign.Fonts.body18SemiBold)
                .foregroundStyle(Color.brandBlack)

            Spacer(minLength: 16)

            Text(value)
                .font(AppDesign.Fonts.body18Redular)
                .foregroundStyle(Color.brandGray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if showsChevron {
                Image(.chevronRight)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 14)
                    .foregroundStyle(Color.brandGray300)
            } else {
                Spacer()
                    .frame(width: 8)
            }
        }
        .frame(height: 60)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.brandGray300)
                .frame(height: 1)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    MyPageProfileEditView(store: Store(initialState: MyPageProfileEditFeature.State(myPage: MyPageSummary(userID: "34", email: "FINQ@gmail.com", nickname: "월급루팡 집사 2세", profileImageCode: "PROFILE_02", profileImageURL: "", totalXP: 20, currentStreakDays: 2, notificationEnabled: true, interests: [MyPageInterest(categoryID: 1, categoryCode: "SAL", categoryName: "월급관리·저축"), MyPageInterest(categoryID: 4, categoryCode: "TAX", categoryName: "세금·절세계좌")]))) {
        EmptyReducer()
    })
}
