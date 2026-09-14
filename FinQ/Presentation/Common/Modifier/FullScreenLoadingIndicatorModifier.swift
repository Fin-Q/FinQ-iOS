//
//  FullScreenLoadingIndicatorModifier.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import SwiftUI

private struct FullScreenLoadingIndicatorModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isPresented)
            .background {
                Color.clear
                    .fullScreenCover(isPresented: $isPresented) {
                        ZStack {
                            Color.black.opacity(0.2)
                                .ignoresSafeArea()

                            ProgressView()
                                .controlSize(.large)
                                .tint(AppDesign.Colors.progress)
                                .padding(24)
                        }
                        .presentationBackground(.clear)
                        .interactiveDismissDisabled()
                    }
                    .transaction { transaction in
                        transaction.disablesAnimations = true
                    }
            }
    }
}

extension View {
    func fullScreenLoadingIndicator(isPresented: Binding<Bool>) -> some View {
        modifier(FullScreenLoadingIndicatorModifier(isPresented: isPresented))
    }
}
