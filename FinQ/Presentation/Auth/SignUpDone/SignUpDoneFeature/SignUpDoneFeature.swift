//
//  SignUpDoneFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUpDoneFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
