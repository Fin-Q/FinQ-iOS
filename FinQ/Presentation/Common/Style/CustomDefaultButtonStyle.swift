//
//  CustomDefaultButtonStyle.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import SwiftUI

struct CustomDefaultButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppDesign.Fonts.buttonTitle)
            .foregroundStyle(
                isEnabled ? .brandWhite : .brandGray
            )
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                isEnabled ? .brandBlue : .brandLightGray
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(
                .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == CustomDefaultButtonStyle {
    static var customDefault: CustomDefaultButtonStyle {
        CustomDefaultButtonStyle()
    }
}
