//
//  CustomOneButtonAlert.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import SwiftUI

struct CustomOneButtonAlert: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onConfirm: () -> Void

    init(title: String, message: String, buttonTitle: String = "확인했어요", onConfirm: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onConfirm = onConfirm
    }

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(AppDesign.Colors.buttonBG)
                .frame(width: 48, height: 48)

            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppDesign.Colors.title)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 32)

            Text(message)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 20)

            Button(buttonTitle, action: onConfirm)
                .buttonStyle(.customDefault)
                .padding(.top, 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 24)
        .frame(maxWidth: 370)
        .background(.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    @Previewable @State var isPresented = true

    ZStack {
        Color.brandWhite.ignoresSafeArea()

        Button("얼럿 띄우기") { isPresented = true }
            .buttonStyle(.customDefault)
            .padding(.horizontal, 16)
    }
    .customOneButtonAlert(isPresented: $isPresented, title: "프리미엄 문제 제목, 곧 만나요", message: "프리미엄 개념은\n지금 열심히 준비 중이에요.")
}
