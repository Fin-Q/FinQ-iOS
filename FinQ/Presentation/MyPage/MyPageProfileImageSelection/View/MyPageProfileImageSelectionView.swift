//
//  MyPageProfileImageSelectionView.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MyPageProfileImageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let store: StoreOf<MyPageProfileImageSelectionFeature>
    private let columns = [GridItem(.flexible(), spacing: 32), GridItem(.flexible(), spacing: 32)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton

            Text("프로필 이미지 선택하기")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 40)

            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(MyPageProfileImageOption.allCases) { option in
                    profileImageButton(option)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 56)

            Spacer(minLength: 32)

            Button {
                HapticManager.selection()
                store.send(.completeButtonTapped)
            } label: {
                Text("완료")
            }
            .buttonStyle(.customDefault)
            .disabled(store.isSaving)
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

    private func profileImageButton(_ option: MyPageProfileImageOption) -> some View {
        let isSelected = store.selectedOption == option

        return Button {
            HapticManager.selection()
            store.send(.profileImageTapped(option))
        } label: {
            Image(option.assetName)
                .resizable()
                .scaledToFill()
                .frame(width: 104, height: 104)
                .clipShape(Circle())
                .overlay {
                    if isSelected {
                        Circle()
                            .strokeBorder(Color.brandBlue, lineWidth: 3)
                            .frame(width: 104, height: 104)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Circle()
                            .fill(Color.brandBlue)
                            .frame(width: 28, height: 28)
                            .overlay {
                                Image(.checkCircle)
                            }
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("프로필 이미지 \(MyPageProfileImageOption.allCases.firstIndex(of: option).map { $0 + 1 } ?? 1)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    MyPageProfileImageSelectionView(store: Store(initialState: MyPageProfileImageSelectionFeature.State(profileImageCode: "PROFILE_02")) {
        EmptyReducer()
    })
}
