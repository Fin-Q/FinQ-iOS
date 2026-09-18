//
//  ContentLearningNavigationButtons.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI

struct ContentLearningNavigationButtons: View {
    var title: String = "다음"
    var isEnabled: Bool = true
    var showsNextChevron: Bool = false
    var onPrevious: (() -> Void)? = nil
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            if let onPrevious {
                Button {
                    HapticManager.selection()
                    onPrevious()
                } label: {
                    HStack(spacing: 12) {
                        chevron(isPrevious: true)
                        Text("이전")
                    }
                }
                .buttonStyle(.customDefault(activeBackgroundColor: Color.brandBlue.opacity(0.12), activeForegroundColor: Color.brandBlue))
                .frame(maxWidth: .infinity)
            }

            Button {
                HapticManager.selection()
                onNext()
            } label: {
                HStack(spacing: 12) {
                    Text(title)
                    if showsNextChevron { chevron(isPrevious: false) }
                }
            }
            .buttonStyle(.customDefault)
            .frame(maxWidth: .infinity)
            .disabled(!isEnabled)
        }
        .id(onPrevious != nil)
        .transition(.identity)
        .animation(nil, value: onPrevious != nil)
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(Color.brandWhite)
    }

    private func chevron(isPrevious: Bool) -> some View {
        Image(isPrevious ? .chevronLeft : .chevronRight)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 8, height: 14)
            .accessibilityHidden(true)
    }
}
