//
//  ContentLearningAnswerIcon.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI

struct ContentLearningAnswerIcon: View {
    let isCircle: Bool
    let color: Color
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        Group {
            if isCircle {
                Circle().strokeBorder(color, lineWidth: lineWidth)
            } else {
                Path { path in
                    let inset = size * 0.15
                    path.move(to: CGPoint(x: inset, y: inset))
                    path.addLine(to: CGPoint(x: size - inset, y: size - inset))
                    path.move(to: CGPoint(x: size - inset, y: inset))
                    path.addLine(to: CGPoint(x: inset, y: size - inset))
                }
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
