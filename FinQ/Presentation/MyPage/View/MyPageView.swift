import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    @Bindable var store: StoreOf<MyPageFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    profileHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    statsCard
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    notificationSection
                        .padding(.horizontal, 20)
                        .padding(.top, 32)

                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    linksSection
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                }
            }
            .background(Color.brandWhite)
            .navigationTitle(store.nickname)
            .navigationBarTitleDisplayMode(.large)
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
            case .profileEdit(let store):
                ProfileEditView(store: store)
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                if !store.interests.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(store.interests, id: \.self) { interest in
                            Text("# \(interest.displayName)")
                                .font(.system(size: 12))
                                .foregroundStyle(AppDesign.Colors.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.brandLightGray)
                                .clipShape(Capsule())
                        }
                    }
                }

                Button {
                    store.send(.profileEditButtonTapped)
                } label: {
                    HStack(spacing: 3) {
                        Text("프로필 수정")
                            .font(AppDesign.Fonts.caption)
                            .foregroundStyle(AppDesign.Colors.caption)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundStyle(AppDesign.Colors.caption)
                    }
                }
            }

            Spacer()

            let code = ProfileImageCode.from(store.profileImageCode)
            Circle()
                .fill(code.displayColor.opacity(0.25))
                .frame(width: 80, height: 80)
                .overlay {
                    Text("\(code.displayNumber)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(code.displayColor)
                }
        }
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        HStack(spacing: 0) {
            statColumn(title: "연속 학습", value: "\(store.currentStreakDays)일차")
            Rectangle().fill(Color.brandLightGray).frame(width: 1, height: 44)
            statColumn(title: "총 XP", value: "\(store.totalXp) XP")
        }
        .padding(.vertical, 20)
        .background(Color.brandWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    private func statColumn(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppDesign.Colors.largeTitle)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Notification Section

    private var notificationSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("알림 설정")
                    .font(AppDesign.Fonts.body)
                    .foregroundStyle(AppDesign.Colors.title)
                Text("허용")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(AppDesign.Colors.caption)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { store.notificationEnabled },
                set: { store.send(.notificationToggled($0)) }
            ))
            .labelsHidden()
            .tint(Color.brandBlack)
        }
    }

    // MARK: - Links Section

    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            linkRow("개인정보 보호정책")
            linkRow("서비스 이용 약관")
            linkRow("계정 관리") {
                store.send(.logoutButtonTapped)
            }
            linkRow("(앱 버전 정보)")
        }
    }

    private func linkRow(_ title: String, action: (() -> Void)? = nil) -> some View {
        Button {
            action?()
        } label: {
            Text(title)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MyPageView(store: .init(initialState: MyPageFeature.State(), reducer: {
        MyPageFeature()
    }))
}
