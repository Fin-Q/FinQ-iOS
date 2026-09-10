//
//  CustomOutlineButtonStyle.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI

struct CustomOutlineButtonStyle: ButtonStyle {
    let isSelected: Bool
    let selectedColor: Color
    
    init(isSelected: Bool, selectedColor: Color) {
        self.isSelected = isSelected
        self.selectedColor = selectedColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(
                isSelected ? AppDesign.Fonts.buttonTitle16SemiBold : AppDesign.Fonts.buttonTitle16
            )
            .foregroundStyle(
                isSelected ? selectedColor : AppDesign.Colors.caption
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? selectedColor : AppDesign.Colors.chevron, lineWidth: isSelected ? 2 : 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 16))
//            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(
                .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == CustomOutlineButtonStyle {
    static func customOutline(isSelected: Bool = false, selectedColor: Color = AppDesign.Colors.buttonBG) -> CustomOutlineButtonStyle {
        CustomOutlineButtonStyle(isSelected: isSelected, selectedColor: selectedColor)
    }
}
