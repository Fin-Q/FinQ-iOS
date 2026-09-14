import Foundation

extension HomeResponse {
    func toDomain() -> HomeData {
        HomeData(
            nickname: nickname,
            level: level,
            characterStage: characterStage,
            totalXp: totalXp,
            currentStreak: currentStreak,
            questions: questions.map { $0.toDomain() }
        )
    }
}

extension QuestionResponse {
    func toDomain() -> QuestionCard {
        QuestionCard(
            contentId: contentId,
            categoryCode: categoryCode,
            categoryName: categoryName,
            title: title,
            isCompleted: completionStatus == "COMPLETED"
        )
    }
}
