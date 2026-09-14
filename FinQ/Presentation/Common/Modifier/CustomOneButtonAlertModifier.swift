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
    let coversEntireScreen: Bool
    let onConfirm: () -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        if coversEntireScreen {
            content
                .allowsHitTesting(!isPresented)
                .background {
                    Color.clear
                        .fullScreenCover(isPresented: $isPresented) {
                            alertLayer
                                .presentationBackground(.clear)
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                }
        } else {
            content
                .allowsHitTesting(!isPresented)
                .overlay {
                    if isPresented {
                        alertLayer
                    }
                }
        }
    }

    private var alertLayer: some View {
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

extension View {
    func customOneButtonAlert(isPresented: Binding<Bool>, title: String, message: String, buttonTitle: String = "확인했어요", coversEntireScreen: Bool = false, onConfirm: @escaping () -> Void = {}) -> some View {
        modifier(CustomOneButtonAlertModifier(isPresented: isPresented, title: title, message: message, buttonTitle: buttonTitle, coversEntireScreen: coversEntireScreen, onConfirm: onConfirm))
    }
}
