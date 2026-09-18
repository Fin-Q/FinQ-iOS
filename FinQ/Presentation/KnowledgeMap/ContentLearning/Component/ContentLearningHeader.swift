//
//  ContentLearningHeader.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import SwiftUI

struct ContentLearningHeader: View {
    @Environment(\.dismiss) private var dismiss
    var title: String = ""
    var currentPage: Int = 0
    var totalPages: Int = 0
    var progress: Double = 0
    var showsProgress: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title)
                    .font(AppDesign.Fonts.subTitle16)
                    .foregroundStyle(Color.brandDarkGray)
                    .lineLimit(1)
                    .padding(.horizontal, 60)

                HStack {
                    Button { dismiss() } label: {
                        Image(.chevronLeft)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 14)
                            .foregroundStyle(Color.brandGray300)
                            .frame(width: 44, height: 44, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("뒤로가기")

                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 44)
            
            if showsProgress && totalPages > 0 {
                HStack(spacing: 8) {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.brandGray300)
                            Capsule().fill(Color.brandBlue).frame(width: proxy.size.width * min(1, max(0, progress)))
                        }
                    }
                    .frame(height: 6)
                    
                    HStack(spacing: 1) {
                        Text("\(currentPage)")
                            .foregroundStyle(Color.brandBlue)
                        
                        Text("/\(totalPages)")
                            .foregroundStyle(Color.brandGray300)
                    }
                    .font(AppDesign.Fonts.captionSemiBold)
                    .fixedSize()
                }
                .frame(height: 22)
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("학습 진행도")
                .accessibilityValue("\(totalPages)개 중 \(currentPage)번째")
            }
        }
    }
}
