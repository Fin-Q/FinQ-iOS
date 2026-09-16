//
//  KnowledgeMapFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct KnowledgeMapFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase
    
    @Reducer
    enum Path {
        case mapDetail(MapDetailFeature)
        case advancedQuizMain(AdvancedQuizMainFeature)
        case advancedQuizIntro(AdvancedQuizIntroFeature)
        case advancedQuizQuestion(AdvancedQuizQuestionFeature)
        case advancedQuizAnswerResult(AdvancedQuizAnswerResultFeature)
        case advancedQuizCompletionSummary(AdvancedQuizCompletionSummaryFeature)
        case advancedQuizCompletion(AdvancedQuizCompletionFeature)
    }

    struct ContentDestination: Equatable {
        let categoryCode: String
        let contentID: Int
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var categories: [KnowledgeMapCategory] = []
        var pendingContentDestination: ContentDestination?
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case fetchCategoriesSucceeded([KnowledgeMapCategory])
        case fetchCategoriesFailed(String)
        case alertOKButtonTapped
        case categoryTapped(KnowledgeMapCategory)
        case openContent(categoryCode: String, contentID: Int)
        case path(StackActionOf<Path>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case contentDestinationReady
            case contentDestinationFailed(String)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let categories = try await knowledgeMapUseCase.fetchCategories()
                        guard !Task.isCancelled else { return }
                        await send(.fetchCategoriesSucceeded(categories))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchCategoriesFailed(error.localizedDescription))
                    }
                }

            case let .fetchCategoriesSucceeded(categories):
                state.categories = categories
                state.isLoading = false

                if let destination = state.pendingContentDestination {
                    state.pendingContentDestination = nil
                    guard navigate(to: destination, state: &state) else {
                        let message = "해당 지식맵 카테고리를 찾을 수 없습니다."
                        return .send(.delegate(.contentDestinationFailed(message)))
                    }
                    return .send(.delegate(.contentDestinationReady))
                }
                return .none

            case let .fetchCategoriesFailed(message):
                let isOpeningContent = state.pendingContentDestination != nil
                state.pendingContentDestination = nil
                state.isLoading = false
                state.errorMessage = isOpeningContent ? nil : message
                return isOpeningContent ? .send(.delegate(.contentDestinationFailed(message))) : .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none
                
            case .categoryTapped(let category):
                state.pendingContentDestination = nil
                state.path.append(.mapDetail(MapDetailFeature.State(category: category)))
                return .none

            case let .openContent(categoryCode, contentID):
                let destination = ContentDestination(categoryCode: categoryCode, contentID: contentID)
                state.errorMessage = nil
                guard !navigate(to: destination, state: &state) else { return .send(.delegate(.contentDestinationReady)) }
                state.pendingContentDestination = destination
                return .send(.onAppear)
                
            case let .path(.element(id: id, action: .mapDetail(.delegate(.advancedQuizRequested(categoryID))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizMain(AdvancedQuizMainFeature.State(categoryID: categoryID)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizMain(.delegate(.advancedQuizIntroRequested(quiz))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizIntro(AdvancedQuizIntroFeature.State(quiz: quiz)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizIntro(.delegate(.advancedQuizQuestionRequested(quiz))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizQuestion(AdvancedQuizQuestionFeature.State(quiz: quiz)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizQuestion(.delegate(.correctAnswerRequested(quiz, questionIndex, result))))):
                guard state.path.ids.last == id else { return .none }
                let orderedQuestions = quiz.questions.sorted { $0.order < $1.order }
                guard orderedQuestions.indices.contains(questionIndex) else { return .none }
                state.path.append(.advancedQuizAnswerResult(AdvancedQuizAnswerResultFeature.State(quiz: quiz, question: orderedQuestions[questionIndex], questionIndex: questionIndex, result: result, presentation: .correct)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizAnswerResult(.delegate(.nextQuestionRequested(quiz, questionIndex))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizQuestion(AdvancedQuizQuestionFeature.State(quiz: quiz, questionIndex: questionIndex)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizAnswerResult(.delegate(.completionSummaryRequested(quiz, categoryResult))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizCompletionSummary(AdvancedQuizCompletionSummaryFeature.State(quiz: quiz, categoryResult: categoryResult)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizCompletionSummary(.delegate(.completionRequested(categoryResult))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizCompletion(AdvancedQuizCompletionFeature.State(categoryResult: categoryResult)))
                return .none

            case let .path(.element(id: id, action: .advancedQuizCompletion(.delegate(.completed)))):
                let pathElements = Array(zip(state.path.ids, state.path))
                guard state.path.ids.last == id, let mapDetailElement = pathElements.last(where: { element in
                    if case .mapDetail = element.1 { return true }
                    return false
                }) else { return .none }
                let mapDetailID = mapDetailElement.0
                state.path.pop(to: mapDetailID)
                return .send(.path(.element(id: mapDetailID, action: .mapDetail(.onAppear))))
                
            case .path, .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

    private func navigate(to destination: ContentDestination, state: inout State) -> Bool {
        guard let category = state.categories.first(where: { $0.topic.rawValue == destination.categoryCode }) else { return false }
        state.path.removeAll()
        state.path.append(.mapDetail(MapDetailFeature.State(category: category, targetContentID: destination.contentID)))
        return true
    }
}

extension KnowledgeMapFeature.Path.State: Equatable {}
