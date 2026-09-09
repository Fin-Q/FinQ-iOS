//
//  CustomOneButtonAlertModifier.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import SwiftUI

private struct CustomOneButtonAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let onConfirm: () -> Void
    
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isPresented)
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        CustomOneButtonAlert(title: title, message: message, buttonTitle: buttonTitle) {
                            isPresented = false
                            onConfirm()
                        }
                        .padding(.horizontal, 16)
                        .offset(y: -40)
                    }
                }
            }
    }
}

extension View {
    func customOneButtonAlert(isPresented: Binding<Bool>, title: String, message: String, buttonTitle: String = "확인했어요", onConfirm: @escaping () -> Void = {}) -> some View {
        modifier(CustomOneButtonAlertModifier(isPresented: isPresented, title: title, message: message, buttonTitle: buttonTitle, onConfirm: onConfirm))
    }
}
