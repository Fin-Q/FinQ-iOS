//
//  MapDetailFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/13/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MapDetailFeature {
    struct State: Equatable {
        let category: KnowledgeMapCategory
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, body in
            switch body {
                
            }
        }
    }
}
