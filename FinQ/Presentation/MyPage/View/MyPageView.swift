//
//  MyPageView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    let store: StoreOf<MyPageFeature>
    
    var body: some View {
        VStack {
            Text("Hello, MyPage!")
            
            Spacer()
                .frame(height: 80)
            
            Button {
                store.send(.logoutButtonTapped)
            } label: {
                Text("로그아웃")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(uiColor: .black))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 14)
        }
    }
}

#Preview {
    MyPageView(store: .init(initialState: MyPageFeature.State(), reducer: {
        MyPageFeature()
    }))
}
