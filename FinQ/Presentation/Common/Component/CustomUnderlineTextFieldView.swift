//
//  CustomUnderlineTextFieldView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI

struct CustomUnderlineTextFieldView: View {
    let title: String
    @Binding var text: String
    
    var showsClearButton: Bool = true
    var onClearTapped: () -> Void = { }
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(title)
                        .foregroundStyle(AppDesign.Colors.placeholder)
                )
                .font(AppDesign.Fonts.textField)
                .foregroundStyle(AppDesign.Colors.title)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                if showsClearButton && !text.isEmpty {
                    Button {
                        onClearTapped()
                    } label: {
                        Image(.xmark)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                            .foregroundStyle(AppDesign.Colors.xmarkGray)
                            .frame(width: 32, height: 40)
                            .contentShape(Rectangle())
                    }
                }
            }
            .frame(height: 40)
            
            Rectangle()
                .fill(AppDesign.Colors.divider)
                .frame(height: 1)
        }
    }
}

#Preview {
    @Previewable @State var text = "ㅁㄴㅇㅁㄴㅇㅁㄴㅇ"
    
    CustomUnderlineTextFieldView(
        title: "테스트",
        text: $text
    )
    .padding(.horizontal, 16)
}
