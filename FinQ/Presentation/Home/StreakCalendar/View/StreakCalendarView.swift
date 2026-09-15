//
//  StreakCalendarView.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct StreakCalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    let store: StoreOf<StreakCalendarFeature>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton
                .padding(.horizontal, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let calendar = store.calendar, let status = store.status {
                        attendanceHeader
                            .padding(.top, 16)

                        streakCard(status)
                            .padding(.top, 24)

                        calendarCard(calendar)
                            .padding(.top, 40)
                    } else if !store.isLoading {
                        Button("다시 불러오기") { store.send(.onAppear) }
                            .buttonStyle(.customDefault)
                            .padding(.top, 32)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.brandLightGray.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
        .task { store.send(.onAppear) }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { store.send(.onAppear) }
        }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.brandGray)
            }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", coversEntireScreen: true, onConfirm: {
            store.send(.alertOKButtonTapped)
        })
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.chevronLeft)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundStyle(Color.brandGray300)
                .frame(width: 44, height: 44, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("뒤로가기")
    }

    private var attendanceHeader: some View {
        HStack(spacing: 16) {
            Text(store.isTodayCompleted ? "출석 인증 완료!" : "오늘도 학습해 볼까요?")
                .font(AppDesign.Fonts.largeTitleSemiBold)
                .foregroundStyle(Color.brandBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: -20)

            Circle()
                .fill(Color.brandGray300.opacity(0.35))
                .frame(width: 104, height: 104)
                .accessibilityHidden(true)
        }
    }

    private func streakCard(_ status: StreakStatus) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HomeProgressBar(progress: status.bonusProgress)
                    .accessibilityHidden(true)

                Image(.gift)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .accessibilityHidden(true)
            }

            Text("\(status.currentStreak)일 연속")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(Color.brandGray)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(status.currentStreak)일 연속 학습")
        .accessibilityValue("다음 스트릭 보상까지 \(status.daysUntilNextBonus)일")
    }

    private func calendarCard(_ calendar: StreakCalendar) -> some View {
        VStack(spacing: 24) {
            Text(monthTitle(calendar.month))
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.brandBlack)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(AppDesign.Fonts.body)
                        .foregroundStyle(Color.brandGray400)
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .accessibilityHidden(true)
                }

                ForEach(Array(days(in: calendar.month).enumerated()), id: \.offset) { _, day in
                    if let day {
                        calendarDay(day, calendar: calendar)
                    } else {
                        Color.clear.frame(height: 36)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
        .simultaneousGesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    guard abs(value.translation.width) >= 50, abs(value.translation.width) > abs(value.translation.height) else { return }
                    HapticManager.selection()
                    store.send(value.translation.width < 0 ? .nextMonthRequested : .previousMonthRequested)
                }
        )
        .accessibilityAction(named: "이전 달") { store.send(.previousMonthRequested) }
        .accessibilityAction(named: "다음 달") { store.send(.nextMonthRequested) }
    }

    private func calendarDay(_ day: Int, calendar: StreakCalendar) -> some View {
        let dateString = calendar.month + String(format: "-%02d", day)
        let isCompleted = calendar.streakDates.contains(dateString)

        return ZStack {
            if isCompleted {
                Image(.checkCircle)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            } else {
                Text("\(day)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.brandGray)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 36)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(calendar.month), \(day)일")
        .accessibilityValue(isCompleted ? "학습 완료" : "학습 기록 없음")
    }

    private func monthTitle(_ month: String) -> String {
        guard let number = month.split(separator: "-").last.flatMap({ Int($0) }) else { return month }
        return String(format: "%02d월", number)
    }

    private func days(in month: String) -> [Int?] {
        let components = month.split(separator: "-").compactMap { Int($0) }
        let calendar = Calendar(identifier: .gregorian)
        guard components.count == 2, (1...12).contains(components[1]), let firstDay = calendar.date(from: DateComponents(year: components[0], month: components[1], day: 1)), let range = calendar.range(of: .day, in: .month, for: firstDay) else { return [] }
        let leadingDays = calendar.component(.weekday, from: firstDay) - 1
        return Array(repeating: nil, count: leadingDays) + range.map { Optional($0) }
    }
}

#Preview {
    NavigationStack {
        StreakCalendarView(store: Store(initialState: StreakCalendarFeature.State(calendar: StreakCalendar(month: "2026-09", streakDates: ["2026-09-01", "2026-09-02", "2026-09-03", "2026-09-04", "2026-09-05"]), status: StreakStatus(currentStreak: 5, daysUntilNextBonus: 3), today: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: 9, day: 5))!, isTodayCompleted: true)) {
            EmptyReducer()
        })
    }
}
