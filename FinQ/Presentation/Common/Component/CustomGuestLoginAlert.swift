//
//  CustomGuestLoginAlert.swift
//  FinQ
//
//  Created by 권대윤 on 9/25/26.
//

import Foundation
import SwiftUI

struct CustomGuestLoginAlert: View {
    let title: String
    let primaryButtonTitle: String
    let cancelButtonTitle: String
    let onPrimary: () -> Void
    let onCancel: () -> Void

    init(title: String, primaryButtonTitle: String = "3초만에 로그인 하기", cancelButtonTitle: String = "닫기", onPrimary: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.title = title
        self.primaryButtonTitle = primaryButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.onPrimary = onPrimary
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(AppDesign.Fonts.largeTitleSemiBold24)
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            Button(primaryButtonTitle, action: onPrimary)
                .buttonStyle(.customDefault)
                .padding(.top, 32)

            Button(cancelButtonTitle, action: onCancel)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                .buttonStyle(.plain)
                .padding(.top, 24)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 24)
        .frame(maxWidth: 370)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }
}
