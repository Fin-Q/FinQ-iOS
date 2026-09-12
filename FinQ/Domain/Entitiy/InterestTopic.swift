//
//  InterestTopic.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

enum InterestTopic: String, CaseIterable, Hashable, Identifiable, Sendable {
    case salaryAndSaving = "SAL"
    case investmentBasics = "INV"
    case stocksAndETF = "STK"
    case taxSaving = "TAX"

    var id: Int {
        switch self {
        case .salaryAndSaving: 1
        case .investmentBasics: 2
        case .stocksAndETF: 3
        case .taxSaving: 4
        }
    }
    
    var title: String {
        switch self {
        case .salaryAndSaving: "월급관리·저축"
        case .investmentBasics: "투자 기초"
        case .stocksAndETF: "주식·ETF"
        case .taxSaving: "세금·절세계좌"
        }
    }

    var knowledgeMapDescription: String {
        switch self {
        case .salaryAndSaving: "월급이 어디로 새는지\n찾아봐요"
        case .investmentBasics: "위험·복리·분산\n투자의 기본기"
        case .stocksAndETF: "주식과 ETF\n이름 읽는 법까지"
        case .taxSaving: "번 돈에서 세금이\n얼마나 나갈까요"
        }
    }

    var cardImageName: String {
        switch self {
        case .salaryAndSaving: "SALBack"
        case .investmentBasics: "INVBack"
        case .stocksAndETF: "STKBack"
        case .taxSaving: "TAXBack"
        }
    }
    
    var isDarkCard: Bool { self == .investmentBasics || self == .stocksAndETF }
}
