//
//  HomeView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Kingfisher

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
                
                if store.isGuestMode {
                    Image(.guestCharacter)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 402, height: 250)
                        .accessibilityHidden(true)
                        .padding(.top, 24)
                        .zIndex(0)
                } else {
                    characterImage(urlString: home.characterImageURL)
                        .padding(.top, 24)
                        .zIndex(0)
                }

                Spacer(minLength: 0)

                if store.isGuestMode {
                    guestRecommendedQuestions(home.questions)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                        .zIndex(1)
                } else {
                    recommendedQuestions(home.questions)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                        .zIndex(1)
                }
            } else {
                profileHeaderPlaceholder
                    .padding(.horizontal, 32)
                    .padding(.top, 16)

                Spacer(minLength: 0)

                recommendedQuestionsPlaceholder
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
            }
        }
        .padding(.bottom, 72)
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
                    .tint(AppDesign.Colors.progress)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            store.send(.alertOKButtonTapped)
        })
        .customGuestLoginAlert(isPresented: Binding(get: { store.isGuestCalendarAlertPresented }, set: { store.send(.guestCalendarAlertPresentedChanged($0)) }), title: "로그인하고 연속 학습 기록을\n확인해보세요", onPrimary: {
            HapticManager.selection()
            store.send(.guestLoginButtonTapped)
        }, onCancel: {
            HapticManager.selection()
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
                    .font(AppDesign.Fonts.captionSemiBold)
                    .foregroundStyle(Color.brandDarkGray)
                    .padding(.horizontal, 12)
                    .frame(height: 30)
                    .background(Color.brandWhite, in: Capsule())

                Text(home.nickname)
                    .font(AppDesign.Fonts.largeBodySemi20)
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            CustomProgressBar(progress: home.levelProgress)
                .accessibilityLabel("레벨 \(home.level), 총 \(home.totalXP) XP")
                .accessibilityValue(home.level == 4 ? "최고 레벨" : "\(Int(home.levelProgress * 100))퍼센트")
        }
    }

    private var profileHeaderPlaceholder: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule()
                .fill(Color.brandGray300)
                .frame(width: 64, height: 30)

            CustomProgressBar(progress: 0)
        }
        .accessibilityHidden(true)
    }

    private var recommendedQuestionsPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.brandWhite)
            .frame(width: 370, height: 276)
            .accessibilityHidden(true)
    }

    private func characterImage(urlString: String) -> some View {
        KFImage(URL(string: urlString))
            .placeholder {
                ProgressView()
                    .tint(AppDesign.Colors.progress)
            }
            .resizable()
            .scaledToFit()
            .frame(width: 402, height: 250)
            .accessibilityHidden(true)
    }

    private func recommendedQuestions(_ questions: [HomeQuestion]) -> some View {
        VStack(alignment: .leading, spacing: 28) {
            if questions.isEmpty {
                Text("추천 질문이 아직 없어요")
                    .font(AppDesign.Fonts.body)
                    .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
                    .frame(maxWidth: .infinity, minHeight: 60)
            } else {
                ForEach(questions) { question in
                    Button {
                        HapticManager.selection()
                        store.send(.questionTapped(question))
                    } label: {
                        HStack(spacing: 16) {
                            questionIcon(categoryCode: question.categoryCode)

                            Text(question.title)
                                .font(AppDesign.Fonts.body)
                                .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
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

    private func guestRecommendedQuestions(_ questions: [HomeQuestion]) -> some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(Array(questions.enumerated()), id: \.offset) { index, item in
                    let opacityValue: Double = switch index {
                    case 0: 0.5
                    case 1: 0.4
                    default: 0.1
                    }
                    
                    guestQuestionRow(title: item.title)
                        .opacity(opacityValue)
                }
            }
            .padding(20)
            .frame(width: 370, height: 276, alignment: .topLeading)
            .accessibilityHidden(true)

            VStack(spacing: 20) {
                Text("로그인하고\n관심 질문을 받아보세요")
                    .font(AppDesign.Fonts.largeTitleSemiBold24)
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity)

                Button {
                    HapticManager.selection()
                    store.send(.guestLoginButtonTapped)
                } label: {
                    Text("3초만에 로그인 하기")
                }
                .buttonStyle(.customDefault)
            }
            .padding(.horizontal, 12)
            .padding(.top, 52)
            .padding(.bottom, 20)
            .background {
                LinearGradient(colors: [Color.brandWhite.opacity(0), Color.brandWhite, Color.brandWhite], startPoint: .top, endPoint: .bottom)
            }
        }
        .frame(width: 370, height: 276)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func guestQuestionRow(title: String) -> some View {
        HStack(spacing: 16) {
            Image("SALIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text(title)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.buttonTitleDarkGray)
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
        }
    }

    @ViewBuilder
    private func questionIcon(categoryCode: String) -> some View {
        if let imageName = questionIconName(categoryCode: categoryCode) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .accessibilityHidden(true)
        } else {
            Rectangle()
                .fill(Color.brandLightGray)
                .frame(width: 60, height: 60)
                .accessibilityHidden(true)
        }
    }

    private func questionIconName(categoryCode: String) -> String? {
        switch categoryCode {
        case InterestTopic.salaryAndSaving.rawValue: "SALIcon"
        case InterestTopic.investmentBasics.rawValue: "INVIcon"
        case InterestTopic.stocksAndETF.rawValue: "STKIcon"
        case InterestTopic.taxSaving.rawValue: "TAXIcon"
        default: nil
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(home: HomeSummary(nickname: "투자박사357", level: 1, characterStage: 1, characterImageURL: "https://finq-assets.s3.ap-northeast-2.amazonaws.com/character-images/character_03.png", totalXP: 24, currentStreak: 5, questions: [
        HomeQuestion(contentID: 4, categoryCode: "SAL", categoryName: "월급관리·저축", title: "예금·적금", completionStatus: .incomplete),
        HomeQuestion(contentID: 5, categoryCode: "SAL", categoryName: "월급관리·저축", title: "목적별 자금 관리", completionStatus: .incomplete),
        HomeQuestion(contentID: 7, categoryCode: "INV", categoryName: "투자기초", title: "복리", completionStatus: .incomplete)
    ]))) {
        EmptyReducer()
    })
}
