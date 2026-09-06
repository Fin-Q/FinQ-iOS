//
//  SignUpTermsFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/5/26.
//

import Foundation
import ComposableArchitecture

enum SignUpTerm: Equatable, Sendable {
    case serviceTerms
    case privacyPolicy
    
    var navigationTitle: String {
        switch self {
        case .serviceTerms:
            return "서비스 이용 약관"
            
        case .privacyPolicy:
            return "개인정보 수집 및 이용"
        }
    }
}

@Reducer
struct SignUpTermsFeature {
    @ObservableState
    struct State: Equatable {
        var isAgeAgreed: Bool = false
        var isServiceAgreed: Bool = false
        var isPrivacyAgreed: Bool = false
        
        var isAllAgreed: Bool {
            return isAgeAgreed && isServiceAgreed && isPrivacyAgreed
        }
    }
    
    enum Action {
        case termRowTapped(SignUpTerm)
        case ageAgreeButtonTapped
        case allAgreeButtonTapped
        case termAgreementChanged(term: SignUpTerm)
        
        case nextButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case pushToSignUpView
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .termRowTapped:
                return .none
                
            case .ageAgreeButtonTapped:
                state.isAgeAgreed.toggle()
                return .none
            
            case .allAgreeButtonTapped:
                Self.setAllAgreements(&state)
                return .none
                
            case .termAgreementChanged(let term):
                switch term {
                case .serviceTerms:
                    state.isServiceAgreed = true
                case .privacyPolicy:
                    state.isPrivacyAgreed = true
                }
                return .none
                
            case .nextButtonTapped:
                guard state.isAllAgreed else { return .none }
                return .send(.delegate(.pushToSignUpView))
                
            case .delegate:
                return .none
            }
        }
    }
    
    private static func setAllAgreements(_ state: inout State) {
        let isAgreed: Bool = state.isAllAgreed ? false : true
        
        state.isAgeAgreed = isAgreed
        state.isServiceAgreed = isAgreed
        state.isPrivacyAgreed = isAgreed
    }
}
