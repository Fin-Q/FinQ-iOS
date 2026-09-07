//
//  AuthMainView.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import SwiftUI
import ComposableArchitecture

struct AuthMainView: View {
    @Bindable var store: StoreOf<AuthMainFeature>
    
    private enum SocialLoginProvider {
        case kakao
        case apple
        
        var image: Image {
            switch self {
            case .kakao:
                Image(.kakaoButton)
                
            case .apple:
                Image(.appleButton)
            }
        }
    }
    @GestureState private var pressedProvider: SocialLoginProvider?
    
    var body: some View {
        NavigationStack(
            path: $store.scope(\.path, action: \.path)
        ) {
            authMainContent
        } destination: { store in
            switch store.case {
            case let .signUpTerms(store):
                SignUpTermsView(store: store)
                
            case let .termsDetail(store):
                TermsDetailView(store: store)
                
            case let .signUp(store):
                SignUpView(store: store)
                
            case let .login(store):
                LoginView(store: store)
                
            case let .findPassword(store):
                FindPasswordView(store: store)
            }
        }
    }
    
    private var authMainContent: some View {
        VStack(alignment: .leading) {
            Text("FINQ")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.bottom, 16)
            
            
            Text("로그인 후 이용해 주세요")
                .font(AppDesign.Fonts.largeTitleBold)
                .foregroundStyle(AppDesign.Colors.largeTitle)
            
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 232)
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 40)
            
            Button {
                store.send(.loginButtonTapped)
            } label: {
                Text("회원 로그인")
            }
            .buttonStyle(
                .customDefault(activeBackgroundColor: AppDesign.Colors.buttonBGDisabled, activeForegroundColor: AppDesign.Colors.buttonTitleBlack)
            )
            .padding(.bottom, 16)
            
            self.socialLoginButton(.kakao) {
                
            }
            .padding(.bottom, 16)
            
            self.socialLoginButton(.apple) {
                
            }
            .padding(.bottom, 31)
            
            HStack(spacing: 40) {
                
                Button {
                    store.send(.findPasswordButtonTapped)
                } label: {
                    Text("비밀번호 찾기")
                        .font(AppDesign.Fonts.body)
                        .tint(AppDesign.Colors.buttonTitleDarkGray)
                        .lineLimit(1)
                }

                Button {
                    store.send(.signUpButtonTapped)
                } label: {
                    Text("회원가입")
                        .font(AppDesign.Fonts.body)
                        .tint(AppDesign.Colors.buttonTitleDarkGray)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }
    
    private func socialLoginButton(_ provider: SocialLoginProvider, action: @escaping () -> Void) -> some View {
        let isPressed = pressedProvider == provider
        
        return Button(action: action) {
            provider.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1)
        .opacity(isPressed ? 0.7 : 1)
        .animation(
            .easeOut(duration: 0.12),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($pressedProvider) { _, state, _ in
                    state = provider
                }
        )
    }
}

#Preview {
    AuthMainView(store: Store(initialState: AuthMainFeature.State(), reducer: {
        AuthMainFeature()
    }))
}
