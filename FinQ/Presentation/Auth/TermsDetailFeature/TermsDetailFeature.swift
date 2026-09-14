//
//  TermsDetailFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TermsDetailFeature {
    @ObservableState
    struct State: Equatable {
        let term: SignUpTerm
        let url: URL
        
        var navigationTitle: String {
            term.navigationTitle
        }
        
        init(term: SignUpTerm) {
            self.term = term
            
            switch term {
            case .serviceTerms:
                self.url = URL(string: "https://app.notion.com/p/3d3cf2fbebb480b7a475cecb555e8c7a?source=copy_link")!
            case .privacyPolicy:
                self.url = URL(string: "https://app.notion.com/p/3d3cf2fbebb480f48193d9bb19bd9b6e?source=copy_link")!   
            }
            
        }
    }
    
    enum Action {
        case agreeButtonTapped
        case delegate(Delegate)
        enum Delegate: Equatable {
            case agreed(SignUpTerm)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .agreeButtonTapped:
                return .send(.delegate(.agreed(state.term)))
                
            case .delegate:
                return .none
            }
        }
    }
}
