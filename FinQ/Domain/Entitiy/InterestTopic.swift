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
}
