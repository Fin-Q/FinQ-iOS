//
//  PasswordResetDoneFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import ComposableArchitecture

@Reducer
struct PasswordResetDoneFeature {
    @ObservableState
    struct State: Equatable {}

    enum Action {
        case navigateLoginButtonTapped
    }

    var body: some ReducerOf<Self> { EmptyReducer() }
}
