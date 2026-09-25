//
//  CustomGuestLoginAlertModifier.swift
//  FinQ
//
//  Created by 권대윤 on 9/25/26.
//

import Foundation
import SwiftUI

private struct CustomGuestLoginAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let primaryButtonTitle: String
    let cancelButtonTitle: String
    let onPrimary: () -> Void
    let onCancel: () -> Void

    func body(content: Content) -> some View {
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
    }

    private var alertLayer: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            CustomGuestLoginAlert(title: title, primaryButtonTitle: primaryButtonTitle, cancelButtonTitle: cancelButtonTitle) {
                onPrimary()
            } onCancel: {
                isPresented = false
                onCancel()
            }
            .padding(.horizontal, 16)
            .offset(y: 0)
        }
    }
}

extension View {
    func customGuestLoginAlert(isPresented: Binding<Bool>, title: String, primaryButtonTitle: String = "3초만에 로그인 하기", cancelButtonTitle: String = "닫기", onPrimary: @escaping () -> Void, onCancel: @escaping () -> Void = {}) -> some View {
        modifier(CustomGuestLoginAlertModifier(isPresented: isPresented, title: title, primaryButtonTitle: primaryButtonTitle, cancelButtonTitle: cancelButtonTitle, onPrimary: onPrimary, onCancel: onCancel))
    }
}
