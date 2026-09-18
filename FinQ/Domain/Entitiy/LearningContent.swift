//
//  LearningContent.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

struct LearningContent: Equatable, Sendable {
    let contentID: Int
    let title: String
    let blocks: [LearningContentBlock]
}

enum LearningContentBlock: Equatable, Sendable {
    case body(LearningBodyBlock)
    case question(LearningQuestionBlock)
}

struct LearningBodyBlock: Equatable, Sendable {
    let title: String
    let elements: [LearningBodyElement]
}

enum LearningBodyElement: Equatable, Sendable {
    case text(String)
    case box([LearningBoxItem])
    case image(String)
    case caption(String)
}

struct LearningBoxItem: Equatable, Sendable {
    let title: String?
    let text: String
}

struct LearningQuestionBlock: Equatable, Sendable {
    let questionID: Int
    let questionType: String
    let questionBody: String
    let options: [LearningQuestionOption]

    var isOX: Bool { questionType == "OX" }
}

struct LearningQuestionOption: Identifiable, Equatable, Sendable {
    let optionID: String
    let optionText: String

    var id: String { optionID }
}
