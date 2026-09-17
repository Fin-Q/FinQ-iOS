//
//  MyPageMainView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Kingfisher

struct MyPageMainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var store: StoreOf<MyPageMainFeature>

    var body: some View {
        NavigationStack(path: $store.scope(\.path, action: \.path)) {
            myPageContent
        } destination: { store in
            switch store.case {
            case let .profileEdit(store):
                MyPageProfileEditView(store: store)

            case let .profileImageSelection(store):
                MyPageProfileImageSelectionView(store: store)

            case let .nicknameEdit(store):
                MyPageNicknameEditView(store: store)

            case let .interestSelection(store):
                MyPageInterestSelectionView(store: store)

            case let .withdrawal(store):
                MyPageWithdrawalView(store: store)

            case let .withdrawalCompletion(store):
                MyPageWithdrawalCompletionView(store: store)

            case let .termsDetail(store):
                TermsDetailView(store: store)
            }
        }
    }

    private var myPageContent: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let myPage = store.myPage {
                        profileSection(myPage)
                            .padding(.top, 64)

                        learningSection(myPage)
                            .padding(.top, 32)

                        notificationSection
                            .padding(.top, 40)

                        informationSection
                            .padding(.top, 40)
                    } else {
                        placeholderContent
                            .padding(.top, 64)
                    }

                    Spacer(minLength: 40)
                    
                    HStack {
                        Button {
                            HapticManager.selection()
                            store.send(.logoutButtonTapped)
                        } label: {
                            Text("로그아웃")
                        }
                        
                        Text("|")
                        
                        Button {
                            HapticManager.selection()
                            store.send(.withdrawalButtonTapped)
                        } label: {
                            Text("회원탈퇴")
                        }
                    }
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(Color.brandGray)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 16)
                .frame(minHeight: max(0, geometry.size.height - 72), alignment: .topLeading)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 72)
        }
        .background(Color.brandLightGray.ignoresSafeArea())
        .task { store.send(.onAppear) }
        .onDisappear { store.send(.onDisappear) }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { store.send(.onAppear) }
        }
        .allowsHitTesting(!store.isLoading && !store.isLoggingOut)
        .overlay {
            if store.isLoading || store.isLoggingOut {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
            }
        }
        .background {
            Color.clear
                .fullScreenCover(isPresented: Binding(get: { store.isLogoutAlertPresented }, set: { isPresented in
                    if !isPresented { store.send(.logoutAlertCancelButtonTapped) }
                })) {
                    logoutAlertLayer
                        .presentationBackground(.clear)
                        .interactiveDismissDisabled()
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
        }
        .customOneButtonAlert(isPresented: Binding(get: { store.errorMessage != nil }, set: { _ in }), title: "알림", message: store.errorMessage ?? "", onConfirm: {
            store.send(.alertOKButtonTapped)
        })
    }

    private func profileSection(_ myPage: MyPageSummary) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                Text(myPage.nickname)
                    .font(AppDesign.Fonts.title20SemiBold)
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(myPage.interests) { interest in
                            Button {
                                HapticManager.selection()
                                store.send(.interestButtonTapped(interest))
                            } label: {
                                Text("#\(interest.categoryName)")
                                    .font(AppDesign.Fonts.caption)
                                    .foregroundStyle(Color.brandDarkGray)
                                    .padding(.horizontal, 12)
                                    .frame(height: 32)
                                    .overlay {
                                        Capsule()
                                            .strokeBorder(Color.brandGray300, lineWidth: 1)
                                    }
                                    .contentShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 16)

                Button {
                    HapticManager.selection()
                    store.send(.profileEditButtonTapped)
                } label: {
                    HStack(spacing: 8) {
                        Text("프로필 수정")
                            .font(AppDesign.Fonts.caption)

                        Image(.chevronRight)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 14)
                    }
                    .foregroundStyle(Color.brandGray400)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            profileImage(myPage.profileImageURL)
        }
    }

    private func profileImage(_ urlString: String) -> some View {
        KFImage(URL(string: urlString))
            .placeholder {
                Circle()
                    .fill(Color.brandGray300.opacity(0.35))
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 104)
            .clipShape(Circle())
    }

    private func learningSection(_ myPage: MyPageSummary) -> some View {
        HStack(spacing: 0) {
            learningItem(title: "연속 학습", value: "\(myPage.currentStreakDays)일차")
            learningItem(title: "총 XP", value: "\(myPage.totalXP)")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 102)
        .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
    }

    private func learningItem(title: String, value: String) -> some View {
        VStack(spacing: 14) {
            Text(title)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(Color.brandGray)

            Text(value)
                .font(AppDesign.Fonts.title20SemiBold)
                .foregroundStyle(Color.brandBlack)
        }
        .frame(maxWidth: .infinity)
    }

    private var notificationSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("알림 설정")
                    .font(AppDesign.Fonts.body16SemiBold)
                    .foregroundStyle(Color.brandBlack)

                Text("허용")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(Color.brandGray)
            }

            Spacer()

            Toggle("알림 설정", isOn: Binding(get: { store.isNotificationEnabled }, set: { store.send(.notificationChanged($0)) }))
                .labelsHidden()
                .tint(Color.brandBlue)
                .disabled(store.isUpdatingNotification)
        }
    }

    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
            
            HStack(spacing: 3) {
                Button {
                    HapticManager.selection()
                    store.send(.serviceTermsButtonTapped)
                } label: {
                    Text("이용약관")
                }
                
                Text("·")
                
                Button {
                    HapticManager.selection()
                    store.send(.privacyPolicyButtonTapped)
                } label: {
                    Text("개인정보처리방침")
                }
            }
            .frame(minHeight: 44)
            .buttonStyle(.plain)

            Text("(앱 버전 v\(appVersion))")
        }
        .font(AppDesign.Fonts.caption)
        .foregroundStyle(AppDesign.Colors.caption)
    }

    private var placeholderContent: some View {
        VStack(spacing: 32) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Capsule().fill(Color.brandGray300.opacity(0.5)).frame(width: 120, height: 24)
                    Capsule().fill(Color.brandGray300.opacity(0.5)).frame(width: 180, height: 32)
                }

                Spacer()

                Circle().fill(Color.brandGray300.opacity(0.35)).frame(width: 104, height: 104)
            }

            RoundedRectangle(cornerRadius: 16)
                .fill(Color.brandWhite)
                .frame(height: 102)
        }
        .accessibilityHidden(true)
    }

    private var logoutAlertLayer: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("정말 로그아웃하시겠어요?")
                    .font(AppDesign.Fonts.title20SemiBold)
                    .foregroundStyle(Color.brandBlack)

                Text("다시 이용하려면 로그인이 필요해요")
                    .font(AppDesign.Fonts.caption)
                    .foregroundStyle(Color.brandGray)
                    .padding(.top, 14)

                HStack(spacing: 20) {
                    Button {
                        HapticManager.selection()
                        store.send(.logoutAlertCancelButtonTapped)
                    } label: {
                        Text("취소하기")
                            .font(AppDesign.Fonts.buttonTitle16SemiBold)
                            .foregroundStyle(Color.brandDarkGray)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.brandLightGray, in: RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                        HapticManager.selection()
                        store.send(.logoutAlertConfirmButtonTapped)
                    } label: {
                        Text("로그아웃")
                            .font(AppDesign.Fonts.buttonTitle16SemiBold)
                            .foregroundStyle(Color.brandRed)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
                            .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(Color.brandRed, lineWidth: 1.5) }
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 28)
            }
            .padding(.horizontal, 20)
            .padding(.top, 28)
            .padding(.bottom, 20)
            .frame(maxWidth: 370)
            .background(Color.brandWhite, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .offset(y: -40)
        }
    }
}

#Preview {
    MyPageMainView(store: Store(initialState: MyPageMainFeature.State(myPage: MyPageSummary(userID: "34", email: "r@r.com", nickname: "월급루팡 2세", profileImageCode: "PROFILE_04", profileImageURL: "https://finq-assets.s3.ap-northeast-2.amazonaws.com/profile-images/profile_04.png", totalXP: 20, currentStreakDays: 2, notificationEnabled: false, interests: [
        MyPageInterest(categoryID: 3, categoryCode: "STK", categoryName: "주식·ETF"),
        MyPageInterest(categoryID: 4, categoryCode: "TAX", categoryName: "세금·절세계좌")
    ]), isNotificationEnabled: false)) {
        EmptyReducer()
    })
}
