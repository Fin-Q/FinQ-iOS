//
//  RandomNicknameGenerator.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

enum RandomNicknameGenerator {
    static func generate() -> String {
        let nouns = [
            "금융새싹", "금융고수", "금융박사", "금융천재", "금융요정", "금융대장",
            "투자새싹", "투자초보", "투자고수", "투자박사", "투자천재", "투자요정",
            "저축새싹", "저축고수", "저축박사", "저축천재", "저축요정", "저축대장",
            "경제새싹", "경제고수", "경제박사", "경제천재", "경제요정", "경제대장",
            "절약새싹", "절약고수", "절약박사", "절약천재", "절약요정", "절약대장",
            "자산새싹", "자산고수", "자산박사", "자산천재", "자산요정", "자산대장",
            "주식새싹", "주식고수", "주식박사", "펀드새싹", "펀드고수", "채권새싹",
            "배당고수", "배당박사", "배당부자", "복리고수", "복리박사", "복리달인",
            "예산고수", "예산박사", "소비고수", "소비박사", "신용고수", "신용박사",
            "현금부자", "저축부자", "투자부자", "통장부자", "가계부왕", "돈관리왕",
            "재테크왕", "머니요정", "금고지기", "돈길잡이"
        ]

        let randomNoun = nouns.randomElement()!
        let randomNumber = Int.random(in: 1...999)
        let numberText = String(format: "%03d", randomNumber)

        return randomNoun + numberText
    }
}
