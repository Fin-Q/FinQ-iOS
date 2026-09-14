//
//  HomeProgressBar.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import SwiftUI

struct HomeProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(Color.brandGray300)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(Color.brandBlue)
                        .frame(width: proxy.size.width * min(1, max(0, progress)))
                }
        }
        .frame(height: 6)
        .accessibilityElement(children: .ignore)
    }
}
