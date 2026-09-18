//
//  ContentLearningText.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI

struct ContentLearningText: View {
    let text: String
    var usesCheckmarks: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: usesCheckmarks ? 20 : 12) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                HStack(alignment: .top, spacing: usesCheckmarks ? 14 : 8) {
                    if usesCheckmarks {
                        Image(.checkBlue)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(Color.brandGray300)
                            .padding(.top, 5)
                            .accessibilityHidden(true)
                    } else if paragraph.isBullet {
                        Circle()
                            .fill(Color.brandDarkGray)
                            .frame(width: 3, height: 3)
                            .frame(width: 12)
                            .padding(.top, 10)
                            .accessibilityHidden(true)
                    }

                    Text(paragraph.text.markdownAttributedString())
                        .font(AppDesign.Fonts.body16Redular)
                        .foregroundStyle(Color.brandDarkGray)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var paragraphs: [(text: String, isBullet: Bool)] {
        let normalizedText = text.replacingOccurrences(of: "\\r\\n", with: "\n").replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
        var result: [(text: String, isBullet: Bool)] = []
        var plainLines: [String] = []

        func appendPlainText() {
            let plainText = plainLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            if !plainText.isEmpty { result.append((plainText, false)) }
            plainLines.removeAll()
        }

        for line in normalizedText.components(separatedBy: "\n") {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if let marker = ["- ", "* ", "• "].first(where: { trimmedLine.hasPrefix($0) }) {
                appendPlainText()
                result.append((String(trimmedLine.dropFirst(marker.count)), true))
            } else if !trimmedLine.isEmpty, line.first?.isWhitespace == true, plainLines.isEmpty, result.last?.isBullet == true {
                result[result.count - 1].text += "\n" + trimmedLine
            } else {
                plainLines.append(line)
            }
        }
        appendPlainText()
        return result
    }
}
