//
//  SplashView.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FINQ")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.top, 64)
                .padding(.horizontal, 16)

            Text("누워서 쓱-보고 익히는 금융 지식")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.top, 28)
                .padding(.horizontal, 16)

            Image(.launchIcon)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.top, 128)
                .accessibilityHidden(true)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandWhite.ignoresSafeArea())
    }
}

#Preview {
    SplashView()
}
