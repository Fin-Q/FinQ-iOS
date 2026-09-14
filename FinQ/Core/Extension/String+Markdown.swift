//
//  String+Markdown.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

extension String {
    func markdownAttributedString(collapseParagraphBreaks: Bool = false) -> AttributedString {
        var normalizedText = normalizedMarkdownLineBreaks

        if collapseParagraphBreaks {
            while normalizedText.contains("\n\n") {
                normalizedText = normalizedText.replacingOccurrences(of: "\n\n", with: "\n")
            }
        }

        let options = AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        return (try? AttributedString(markdown: normalizedText, options: options)) ?? AttributedString(normalizedText)
    }

    func markdownBulletList() -> (introduction: String, items: [String]) {
        let lines = normalizedMarkdownLineBreaks.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let firstBulletIndex = lines.firstIndex(where: { $0.hasPrefix("- ") }) ?? lines.endIndex
        let introduction = lines[..<firstBulletIndex].filter { !$0.isEmpty }.joined(separator: "\n")
        let items = lines[firstBulletIndex...].filter { $0.hasPrefix("- ") }.map { String($0.dropFirst(2)) }
        return (introduction, items)
    }

    private var normalizedMarkdownLineBreaks: String {
        return replacingOccurrences(of: "\\r\\n", with: "\n")
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
    }
}
