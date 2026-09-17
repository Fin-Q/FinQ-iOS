//
//  ContentLearningBodyView.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Kingfisher

struct ContentLearningBodyView: View {
    let store: StoreOf<ContentLearningFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ContentLearningHeader(title: store.content?.title ?? "", currentPage: store.currentBodyBlockNumber, totalPages: store.totalBodyBlockCount, progress: store.progress, showsProgress: store.isProgressVisible)

            ScrollView {
                if case let .body(block)? = store.currentBlock {
                    bodyBlock(block)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                }
            }
            .id(store.currentBlockIndex)
            .scrollIndicators(.hidden)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ContentLearningNavigationButtons(isEnabled: store.isNextButtonEnabled, showsNextChevron: true, onPrevious: store.canMovePrevious ? { store.send(.previousButtonTapped) } : nil, onNext: { store.send(.nextButtonTapped) })
        }
    }

    private func bodyBlock(_ block: LearningBodyBlock) -> some View {
        let isSummary = block.title.replacingOccurrences(of: " ", with: "") == "핵심정리"

        return VStack(alignment: .leading, spacing: 0) {
            Text(block.title)
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(Color.brandBlack)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(Array(block.elements.enumerated()), id: \.offset) { index, element in
                bodyElement(element, isSummary: isSummary)
                    .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func bodyElement(_ element: LearningBodyElement, isSummary: Bool) -> some View {
        switch element {
        case let .text(text):
            ContentLearningText(text: text)

        case let .box(items):
            ContentLearningBoxView(items: items, usesCheckmarks: isSummary)

        case let .image(rawURL):
            learningImage(rawURL)

        case let .caption(text):
            Text(text.markdownAttributedString(collapseParagraphBreaks: true))
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(Color.brandGray)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func learningImage(_ rawURL: String) -> some View {
        if let url = imageURL(from: rawURL) {
            KFImage(url)
                .placeholder {
                    Rectangle()
                        .fill(Color.brandLightGray)
                        .aspectRatio(1.6, contentMode: .fit)
                        .overlay { ProgressView().tint(AppDesign.Colors.progress) }
                }
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } else {
            Rectangle()
                .fill(Color.brandLightGray)
                .aspectRatio(1.6, contentMode: .fit)
                .overlay {
                    Text("이미지를 불러올 수 없어요.")
                        .font(AppDesign.Fonts.caption)
                        .foregroundStyle(Color.brandGray)
                }
        }
    }

    private func imageURL(from rawValue: String) -> URL? {
        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if let separatorRange = trimmedValue.range(of: "]("), trimmedValue.hasSuffix(")") {
            return URL(string: String(trimmedValue[separatorRange.upperBound..<trimmedValue.index(before: trimmedValue.endIndex)]))
        }
        return URL(string: trimmedValue)
    }
}
