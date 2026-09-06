//
//  SignUpView.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    let store: StoreOf<SignUpFeature>
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    SignUpView(store: .init(initialState: SignUpFeature.State(), reducer: {
        SignUpFeature()
    }))
}
