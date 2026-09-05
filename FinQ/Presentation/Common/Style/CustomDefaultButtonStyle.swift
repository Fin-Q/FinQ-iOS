//
//  CustomDefaultButtonStyle.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import SwiftUI

struct CustomDefaultButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    let activeBackgroundColor: Color
    let activeForegroundColor: Color
    
    init(
        activeBackgroundColor: Color = AppDesign.Colors.buttonBG,
        activeForegroundColor: Color = AppDesign.Colors.buttonTitle
    ) {
        self.activeBackgroundColor = activeBackgroundColor
        self.activeForegroundColor = activeForegroundColor
    }


    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppDesign.Fonts.buttonTitle)
            .foregroundStyle(
                isEnabled ? activeForegroundColor : AppDesign.Colors.buttonTitleDisabled
            )
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                isEnabled ? activeBackgroundColor : AppDesign.Colors.buttonBGDisabled
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: 16,
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
    
    static func customDefault(activeBackgroundColor: Color, activeForegroundColor: Color) -> CustomDefaultButtonStyle {
        CustomDefaultButtonStyle(
            activeBackgroundColor: activeBackgroundColor,
            activeForegroundColor: activeForegroundColor
        )
    }
}
