//
//  HomeView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)) {
            homeContent
        } destination: { store in
            switch store.case {
            case let .streakCalendar(store):
                StreakCalendarView(store: store)
            }
        }
    }

    private var homeContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            calendarButton
                .padding(.horizontal, 16)

            if let home = store.home {
                profileHeader(home)
                    .padding(.horizontal, 32)
                    .padding(.top, 16)

                Spacer(minLength: 24)

                recommendedQuestions(home.questions)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            } else if !store.isLoading {
                Button("다시 불러오기") { store.send(.onAppear) }
                    .buttonStyle(.customDefault)
                    .padding(32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandSkyBlue.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.onAppear) }
        .onDisappear { store.send(.onDisappear) }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { store.send(.onAppear) }
        }
        .allowsHitTesting(!store.isLoading)
        .overlay {
            if store.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.brandGray)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            store.send(.alertOKButtonTapped)
        })
    }

    private var calendarButton: some View {
        HStack {
            Spacer()
            Button {
                HapticManager.selection()
                store.send(.calendarButtonTapped)
            } label: {
                Image(.calendar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("학습 캘린더")
        }
    }

    private func profileHeader(_ home: HomeSummary) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("레벨 \(home.level)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.brandDarkGray)
                    .padding(.horizontal, 12)
                    .frame(height: 30)
                    .background(Color.brandWhite, in: Capsule())

                Text(home.nickname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            HomeProgressBar(progress: home.levelProgress)
                .accessibilityLabel("레벨 \(home.level), 총 \(home.totalXP) XP")
                .accessibilityValue(home.level == 4 ? "최고 레벨" : "\(Int(home.levelProgress * 100))퍼센트")
        }
    }

    private func recommendedQuestions(_ questions: [HomeQuestion]) -> some View {
        VStack(alignment: .leading, spacing: 28) {
            if questions.isEmpty {
                Text("추천 질문이 아직 없어요")
                    .font(AppDesign.Fonts.body)
                    .foregroundStyle(Color.brandGray)
                    .frame(maxWidth: .infinity, minHeight: 60)
            } else {
                ForEach(questions) { question in
                    Button {
                        HapticManager.selection()
                        store.send(.questionTapped(question))
                    } label: {
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.brandLightGray)
                                .frame(width: 60, height: 60)
                                .accessibilityHidden(true)

                            Text(question.title)
                                .font(AppDesign.Fonts.body)
                                .foregroundStyle(Color.brandGray)
                                .lineSpacing(5)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Image(.chevronRight)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8, height: 14)
                                .foregroundStyle(Color.brandGray300)
                                .accessibilityHidden(true)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .padding(20)
        .frame(width: 370, height: 276, alignment: .leading)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(home: HomeSummary(nickname: "투자박사357", level: 1, characterStage: 1, totalXP: 24, currentStreak: 5, questions: [
        HomeQuestion(contentID: 4, categoryCode: "SAL", categoryName: "월급관리·저축", title: "예금·적금", completionStatus: .incomplete),
        HomeQuestion(contentID: 5, categoryCode: "SAL", categoryName: "월급관리·저축", title: "목적별 자금 관리", completionStatus: .incomplete),
        HomeQuestion(contentID: 7, categoryCode: "INV", categoryName: "투자기초", title: "복리", completionStatus: .incomplete)
    ]))) {
        EmptyReducer()
    })
}
