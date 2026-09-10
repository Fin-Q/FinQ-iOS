//
//  CustomUnderlineSecureFieldView.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI

struct CustomUnderlineSecureFieldView: View {
    let title: String
    @Binding var text: String
    
    var onClearTapped: () -> Void = { }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                SecureField(
                    "",
                    text: $text,
                    prompt: Text(title)
                        .foregroundStyle(AppDesign.Colors.placeholder)
                )
                .font(AppDesign.Fonts.textField)
                .foregroundStyle(AppDesign.Colors.title)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                if !text.isEmpty {
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
                    .buttonStyle(.plain)
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
    @Previewable @State var text = "password123@"
    
    CustomUnderlineSecureFieldView(
        title: "비밀번호",
        text: $text
    )
    .padding(.horizontal, 16)
}
