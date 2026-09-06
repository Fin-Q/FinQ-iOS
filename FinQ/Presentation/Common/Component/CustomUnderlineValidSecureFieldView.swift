//
//  CustomUnderlineValidSecureFieldView.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import SwiftUI

struct CustomUnderlineValidSecureFieldView: View {
    enum ValidationState: Equatable {
        case idle
        case valid
        case invalid(message: String?)
    }
    
    let title: String
    @Binding var text: String
    var validationState: ValidationState = .idle
    var onEditingEnded: () -> Void = { }

    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                .focused($isFocused)
                .onChange(of: isFocused) { oldValue, newValue in
                    guard oldValue, !newValue else {
                        return
                    }

                    onEditingEnded()
                }
                
                validationIcon
            }
            .frame(height: 40)
            
            Rectangle()
                .fill(AppDesign.Colors.divider)
                .frame(height: 1)
            
            if case let .invalid(message?) = validationState {
                Text(message)
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.captionInvalid)
                    .padding(.top, 8)
            }
        }
    }
    
    @ViewBuilder
    private var validationIcon: some View {
        switch validationState {
        case .idle:
            EmptyView()
            
        case .valid:
            Image(.checkGreen)
            
        case .invalid:
            Image(.xmark)
        }
    }
}
