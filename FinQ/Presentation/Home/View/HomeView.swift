import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    userInfoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    characterImagePlaceholder
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    questionsSection
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                }
            }
            .background(Color.brandWhite)
            .onAppear { store.send(.onAppear) }
            .overlay {
                if store.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(AppDesign.Colors.progress)
                }
            }
        } destination: { store in
            switch store.case {
            case .streakDetail(let store):
                StreakDetailView(store: store)
            case .notification(let store):
                NotificationView(store: store)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()
            Button {
                store.send(.streakButtonTapped)
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.brandBlack)
            }
            Button {
                store.send(.notificationButtonTapped)
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.brandBlack)
            }
            .padding(.leading, 16)
        }
    }

    // MARK: - User Info

    private var userInfoSection: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 6) {
                Text("레벨 \(store.level)")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.caption)

                Text(store.nickname)
                    .font(AppDesign.Fonts.body)
                    .foregroundStyle(AppDesign.Colors.title)

                Button {
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundStyle(AppDesign.Colors.caption)
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.brandLightGray)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.brandBlue)
                        .frame(width: proxy.size.width * xpProgress, height: 6)
                }
            }
            .frame(height: 6)
        }
        .frame(maxWidth: .infinity)
    }

    private var xpProgress: Double {
        switch store.level {
        case 1: return min(Double(store.totalXp) / 80.0, 1.0)
        case 2: return min(Double(store.totalXp - 80) / 100.0, 1.0)
        case 3: return min(Double(store.totalXp - 180) / 120.0, 1.0)
        default: return 1.0
        }
    }

    // MARK: - Character Image Placeholder

    private var characterImagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.brandLightGray)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.brandGray)
            }
    }

    // MARK: - Questions

    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("관심 주제")
                .font(AppDesign.Fonts.largeBody)
                .foregroundStyle(AppDesign.Colors.title)

            VStack(spacing: 12) {
                if store.questions.isEmpty && !store.isLoading {
                    Text("추천 질문이 없습니다.")
                        .font(AppDesign.Fonts.caption)
                        .foregroundStyle(AppDesign.Colors.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(store.questions) { question in
                        QuestionCardView(question: question) {
                            store.send(.questionTapped(question))
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Question Card View

private struct QuestionCardView: View {
    let question: QuestionCard
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.brandLightGray)
                    .frame(width: 72, height: 72)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(Color.brandGray)
                    }

                Text(question.title)
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppDesign.Colors.caption)
            }
            .padding(14)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandLightGray, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State()) {
        HomeFeature()
    })
}
