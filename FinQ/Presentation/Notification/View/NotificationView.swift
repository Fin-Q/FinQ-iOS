import SwiftUI
import ComposableArchitecture

struct NotificationView: View {
    let store: StoreOf<NotificationFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(store.notifications) { item in
                    NotificationRow(item: item)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.brandWhite)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.large)
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
}

private struct NotificationRow: View {
    let item: NotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.brandLightGray)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(AppDesign.Fonts.caption)
                        .foregroundStyle(AppDesign.Colors.title)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(item.timeAgo)
                        .font(.system(size: 12))
                        .foregroundStyle(AppDesign.Colors.caption)
                }
                Text(item.description)
                    .font(.system(size: 12))
                    .foregroundStyle(AppDesign.Colors.caption)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.brandLightGray, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        NotificationView(store: Store(initialState: NotificationFeature.State()) {
            NotificationFeature()
        })
    }
}
