//
//  LearningContentMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

extension LearningContentResponse {
    func toDomain() throws -> LearningContent {
        return LearningContent(contentID: contentID, title: title, blocks: try blocks.map { try $0.toDomain() })
    }
}

private extension LearningContentBlockResponse {
    func toDomain() throws -> LearningContentBlock {
        switch blockType {
        case "BODY":
            guard let title, let content else { throw LearningContentMappingError.invalidBodyBlock }
            return .body(LearningBodyBlock(title: title, elements: try content.map { try $0.toDomain() }))

        case "QUESTION":
            guard let questionID, let questionType, let questionBody, let options else { throw LearningContentMappingError.invalidQuestionBlock }
            return .question(LearningQuestionBlock(questionID: questionID, questionType: questionType, questionBody: questionBody, options: options.map { $0.toDomain() }))

        default:
            throw LearningContentMappingError.unsupportedBlockType(blockType)
        }
    }
}

private extension LearningBodyElementResponse {
    func toDomain() throws -> LearningBodyElement {
        switch type {
        case "TEXT":
            guard let text else { throw LearningContentMappingError.invalidBodyElement }
            return .text(text)

        case "BOX":
            guard let items else { throw LearningContentMappingError.invalidBodyElement }
            return .box(items.map { $0.toDomain() })

        case "IMAGE":
            guard let imageURL else { throw LearningContentMappingError.invalidBodyElement }
            return .image(imageURL)

        case "CAPTION":
            guard let text else { throw LearningContentMappingError.invalidBodyElement }
            return .caption(text)

        default:
            throw LearningContentMappingError.unsupportedElementType(type)
        }
    }
}

private extension LearningBoxItemResponse {
    func toDomain() -> LearningBoxItem {
        return LearningBoxItem(title: title, text: text)
    }
}

private extension LearningQuestionOptionResponse {
    func toDomain() -> LearningQuestionOption {
        return LearningQuestionOption(optionID: optionID, optionText: optionText)
    }
}

extension ContentAnswerResponse {
    func toDomain() throws -> ContentAnswerResult {
        let rawNextAction = nextAction
        guard let nextAction = ContentNextAction(rawValue: rawNextAction) else { throw LearningContentMappingError.unsupportedNextAction(rawNextAction) }
        return ContentAnswerResult(correct: correct, explanation: explanation, selectedOptionID: selectedOptionID, correctOptionID: correctOptionID, nextAction: nextAction, contentResult: contentResult?.toDomain())
    }
}

private extension ContentCompletionResultResponse {
    func toDomain() -> ContentCompletionResult {
        return ContentCompletionResult(earnedXP: earnedXP, levelUp: levelUp, newLevel: newLevel)
    }
}

private enum LearningContentMappingError: LocalizedError {
    case invalidBodyBlock
    case invalidQuestionBlock
    case invalidBodyElement
    case unsupportedBlockType(String)
    case unsupportedElementType(String)
    case unsupportedNextAction(String)

    var errorDescription: String? {
        switch self {
        case .invalidBodyBlock, .invalidQuestionBlock, .invalidBodyElement:
            return "학습 콘텐츠 정보를 불러오지 못했어요. 다시 시도해 주세요."
        case let .unsupportedBlockType(type):
            return "지원하지 않는 학습 블록 형식이에요. (\(type))"
        case let .unsupportedElementType(type):
            return "지원하지 않는 학습 콘텐츠 형식이에요. (\(type))"
        case let .unsupportedNextAction(action):
            return "지원하지 않는 학습 진행 방식이에요. (\(action))"
        }
    }
}
