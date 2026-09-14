import SwiftUI
import ComposableArchitecture

struct StreakDetailView: View {
    let store: StoreOf<StreakDetailFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                completionHeader
                streakProgressCard
                calendarSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.brandWhite)
        .navigationBarBackButtonHidden(true)
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.brandBlack)
                        .fontWeight(.medium)
                }
            }
        }
    }

    // MARK: - Completion Header

    private var completionHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("출석 인증 완료!")
                    .font(AppDesign.Fonts.largeTitleBold)
                    .foregroundStyle(AppDesign.Colors.largeTitle)

                Text("오늘 \(store.todayStudyMinutes)분 학습 중")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.caption)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.brandLightGray)
                .frame(width: 110, height: 110)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.brandGray)
                )
        }
    }

    // MARK: - Streak Progress Card

    private var streakProgressCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.brandLightGray)
                        .frame(height: 20)

                    let total = Double(store.streakDays + store.daysUntilNextBonus)
                    Capsule()
                        .fill(Color.brandBlack.opacity(0.75))
                        .frame(width: proxy.size.width * (total > 0 ? min(Double(store.streakDays) / total, 1.0) : 0), height: 20)

                    Circle()
                        .fill(Color.brandBlack)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "gift.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.brandWhite)
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .frame(height: 36)

            Text("\(store.streakDays)일 연속")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
        }
        .padding(16)
        .background(Color.brandLightGray.opacity(0.4))
        .cornerRadius(12)
    }

    // MARK: - Calendar

    private var calendarSection: some View {
        VStack(spacing: 16) {
            Text(String(format: "%02d월", store.month))
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.title)

            StreakCalendarGrid(
                year: store.year,
                month: store.month,
                attendedDays: store.attendedDays,
                todayDay: store.todayDay
            )
        }
    }
}

// MARK: - Calendar Grid

private struct StreakCalendarGrid: View {
    let year: Int
    let month: Int
    let attendedDays: Set<Int>
    let todayDay: Int

    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    private var firstWeekdayOffset: Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        guard let date = Calendar.current.date(from: comps) else { return 0 }
        return Calendar.current.component(.weekday, from: date) - 1
    }

    private var daysInMonth: Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        guard let date = Calendar.current.date(from: comps),
              let range = Calendar.current.range(of: .day, in: .month, for: date) else { return 30 }
        return range.count
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(AppDesign.Fonts.caption)
                        .foregroundStyle(AppDesign.Colors.caption)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<firstWeekdayOffset, id: \.self) { _ in
                    Color.clear.frame(height: 36)
                }
                ForEach(1...daysInMonth, id: \.self) { day in
                    StreakDayCell(
                        day: day,
                        isAttended: attendedDays.contains(day),
                        isToday: day == todayDay
                    )
                }
            }
        }
    }
}

private struct StreakDayCell: View {
    let day: Int
    let isAttended: Bool
    let isToday: Bool

    var body: some View {
        ZStack {
            if isToday {
                Circle()
                    .fill(Color.brandBlue)
                    .frame(width: 34, height: 34)
                Text("\(day)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.brandWhite)
            } else if isAttended {
                Circle()
                    .fill(Color.brandBlack.opacity(0.75))
                    .frame(width: 34, height: 34)
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.brandWhite)
            } else {
                Text("\(day)")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.title)
            }
        }
        .frame(width: 36, height: 36)
    }
}

#Preview {
    NavigationStack {
        StreakDetailView(store: Store(initialState: StreakDetailFeature.State()) {
            StreakDetailFeature()
        })
    }
}
