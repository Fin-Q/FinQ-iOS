//
//  SignUpTermsView.swift
//  FinQ
//
//  Created by 권대윤 on 9/5/26.
//

import SwiftUI
import ComposableArchitecture

struct SignUpTermsView: View {
    let store: StoreOf<SignUpTermsFeature>
    
    var body: some View {
        VStack {
            VStack {
                Text("서비스 이용 약관")
                    .font(AppDesign.Fonts.largeTitleSemiBold)
                    .foregroundStyle(AppDesign.Colors.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 40)
                
                Button {

                    } label: {
                        HStack {
                            Image(.checkCircleDisabled)

                            Text("모두 동의합니다")
                                .font(AppDesign.Fonts.buttonTitle16SemiBold)
                                .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                
                Rectangle()
                    .fill(AppDesign.Colors.divider)
                    .frame(height: 1)
                    .padding(.vertical, 8)
                
                Button {
                    
                } label: {
                    HStack(spacing: 8) {
                        Image(.check)

                        Text("만 14세 이상입니다 (필수)")
                            .font(AppDesign.Fonts.buttonTitle16)
                            .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                            .padding(.leading, 5)

                        Spacer()

                        Image(.chevronRight)
                            .renderingMode(.template)
                            .foregroundStyle(AppDesign.Colors.chevron)
                    }
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    HStack(spacing: 8) {
                        Image(.check)

                        Text("서비스 이용 약관에 동의 (필수)")
                            .font(AppDesign.Fonts.buttonTitle16)
                            .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                            .padding(.leading, 5)

                        Spacer()

                        Image(.chevronRight)
                            .renderingMode(.template)
                            .foregroundStyle(AppDesign.Colors.chevron)
                    }
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    HStack(spacing: 8) {
                        Image(.check)

                        Text("개인정보 수집 및 이용에 동의 (필수)")
                            .font(AppDesign.Fonts.buttonTitle16)
                            .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                            .padding(.leading, 5)

                        Spacer()

                        Image(.chevronRight)
                            .renderingMode(.template)
                            .foregroundStyle(AppDesign.Colors.chevron)
                    }
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("다음")
                    
            }
            .buttonStyle(.customDefault)
            .padding(.bottom, 64)
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignUpTermsView(
        store: Store(initialState: SignUpTermsFeature.State()) {
            SignUpTermsFeature()
        }
    )
}
