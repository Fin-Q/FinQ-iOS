//
//  AuthMainView.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import SwiftUI
import ComposableArchitecture

struct AuthMainView: View {
    let store: StoreOf<AuthMainFeature>
    
    var body: some View {
        Spacer()
        
        Text("Hello, AuthMainView!")
        
        Spacer()
        
        Button {
            store.send(.loginButtonTapped)
        } label: {
            Text("로그인")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color(uiColor: .black))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 14)
        
        Spacer()
    }
}

#Preview {
    AuthMainView(store: Store(initialState: AuthMainFeature.State(), reducer: {
        AuthMainFeature()
    }))
}
