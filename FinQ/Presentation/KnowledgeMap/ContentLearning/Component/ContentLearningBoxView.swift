//
//  ContentLearningBoxView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI

struct ContentLearningBoxView: View {
    let items: [LearningBoxItem]
    var usesCheckmarks: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                box(item)
            }
        }
    }

    private func box(_ item: LearningBoxItem) -> some View {
        let title = item.title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        return VStack(alignment: .leading, spacing: 16) {
            if !title.isEmpty {
                Text(title.markdownAttributedString())
                    .font(AppDesign.Fonts.title20SemiBold)
                    .foregroundStyle(Color.brandBlack)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ContentLearningText(text: item.text, usesCheckmarks: usesCheckmarks)
        }
        .padding(.horizontal, title.isEmpty ? 24 : 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
    }
}
