import SwiftUI
import ComposableArchitecture

struct ProfileEditView: View {
    @Bindable var store: StoreOf<ProfileEditFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileImageSection
                    .padding(.top, 32)
                    .padding(.bottom, 40)

                Divider()

                infoRows
            }
        }
        .background(Color.brandWhite)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.brandBlack)
                        .fontWeight(.medium)
                }
            }
        }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(AppDesign.Colors.progress)
            }
        }
        .sheet(isPresented: $store.isEditingNickname) {
            nicknameEditSheet
                .presentationDetents([.height(240)])
        }
        .sheet(isPresented: $store.isSelectingImage) {
            imagePickerSheet
                .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $store.isSelectingInterests) {
            interestSelectionSheet
                .presentationDetents([.medium])
        }
    }

    // MARK: - Profile Image

    private var profileImageSection: some View {
        Button {
            store.send(.profileImageTapped)
        } label: {
            ZStack(alignment: .bottomTrailing) {
                profileCircle(code: store.profileImageCode, size: 100)

                Circle()
                    .fill(Color.brandGray)
                    .frame(width: 28, height: 28)
                    .overlay {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.brandWhite)
                    }
                    .offset(x: 4, y: 4)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Info Rows

    private var infoRows: some View {
        VStack(spacing: 0) {
            Button { store.send(.nicknameTapped) } label: {
                profileRow(title: "닉네임", value: store.nickname, showChevron: true)
            }
            .buttonStyle(.plain)

            Divider().padding(.horizontal, 20)

            profileRow(title: "아이디", value: store.email, showChevron: false)

            Divider().padding(.horizontal, 20)

            interestRow
        }
    }

    private var interestRow: some View {
        Button { store.send(.interestsTapped) } label: {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("관심 주제")
                        .font(AppDesign.Fonts.body)
                        .foregroundStyle(AppDesign.Colors.title)

                    if store.interests.isEmpty {
                        Text("관심 주제를 선택해주세요")
                            .font(AppDesign.Fonts.caption)
                            .foregroundStyle(AppDesign.Colors.caption)
                    } else {
                        FlowLayout(spacing: 8) {
                            ForEach(store.interests, id: \.self) { interest in
                                Text("# \(interest.displayName)")
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppDesign.Colors.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.brandLightGray)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppDesign.Colors.caption)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Interest Selection Sheet

    private var interestSelectionSheet: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("관심 주제 선택")
                .font(.headline)
                .foregroundStyle(AppDesign.Colors.largeTitle)
                .padding(.horizontal, 24)

            Text("하나 이상 선택해주세요")
                .font(AppDesign.Fonts.caption)
                .foregroundStyle(AppDesign.Colors.caption)
                .padding(.horizontal, 24)

            FlowLayout(spacing: 12) {
                ForEach(InterestTopic.allCases) { topic in
                    let isSelected = store.selectedInterests.contains(topic)
                    Button { store.send(.interestToggled(topic)) } label: {
                        Text("# \(topic.displayName)")
                            .font(.system(size: 14))
                            .foregroundStyle(isSelected ? Color.brandWhite : AppDesign.Colors.caption)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color.brandBlack : Color.brandLightGray)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                store.send(.confirmInterestSelection)
            } label: {
                Text("완료")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(store.selectedInterests.isEmpty ? Color.brandGray : Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(store.selectedInterests.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileRow(title: String, value: String, showChevron: Bool) -> some View {
        HStack {
            Text(title)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.title)
            Spacer()
            Text(value)
                .font(AppDesign.Fonts.body)
                .foregroundStyle(AppDesign.Colors.caption)
                .lineLimit(1)
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppDesign.Colors.caption)
                    .padding(.leading, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Nickname Edit Sheet

    private var nicknameEditSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("닉네임 변경")
                .font(.headline)
                .foregroundStyle(AppDesign.Colors.largeTitle)

            VStack(alignment: .leading, spacing: 6) {
                TextField("닉네임 입력 (최대 15자)", text: $store.editNicknameText)
                    .font(AppDesign.Fonts.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.brandLightGray.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                if let error = store.nicknameError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Button {
                store.send(.confirmNicknameEdit)
            } label: {
                Text("변경하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Image Picker Sheet

    private var imagePickerSheet: some View {
        VStack(spacing: 20) {
            Text("프로필 이미지 선택")
                .font(.headline)
                .foregroundStyle(AppDesign.Colors.largeTitle)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(ProfileImageCode.allCases, id: \.rawValue) { code in
                    Button {
                        store.send(.profileImageSelected(code.rawValue))
                    } label: {
                        ZStack {
                            profileCircle(code: code.rawValue, size: 64)
                            if store.profileImageCode == code.rawValue {
                                Circle()
                                    .stroke(Color.brandBlack, lineWidth: 3)
                                    .frame(width: 64, height: 64)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Button {
                store.send(.dismissImagePicker)
            } label: {
                Text("취소")
                    .font(AppDesign.Fonts.body)
                    .foregroundStyle(AppDesign.Colors.caption)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Helper

    private func profileCircle(code: String, size: CGFloat) -> some View {
        let imageCode = ProfileImageCode.from(code)
        return Circle()
            .fill(imageCode.displayColor.opacity(0.25))
            .frame(width: size, height: size)
            .overlay {
                Text("\(imageCode.displayNumber)")
                    .font(.system(size: size * 0.35, weight: .bold))
                    .foregroundStyle(imageCode.displayColor)
            }
    }
}
