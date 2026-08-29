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
        Text("Hello, MyPage!")
    }
}

#Preview {
    MyPageView(store: .init(initialState: MyPageFeature.State(), reducer: {
        MyPageFeature()
    }))
}
