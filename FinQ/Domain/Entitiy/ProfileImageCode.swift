import SwiftUI

enum ProfileImageCode: String, CaseIterable, Equatable, Hashable, Sendable {
    case profile01 = "PROFILE_01"
    case profile02 = "PROFILE_02"
    case profile03 = "PROFILE_03"
    case profile04 = "PROFILE_04"

    var displayColor: Color {
        switch self {
        case .profile01: .blue
        case .profile02: .green
        case .profile03: .orange
        case .profile04: .purple
        }
    }

    var displayNumber: Int {
        switch self {
        case .profile01: 1
        case .profile02: 2
        case .profile03: 3
        case .profile04: 4
        }
    }

    static func from(_ raw: String) -> ProfileImageCode {
        ProfileImageCode(rawValue: raw) ?? .profile01
    }
}
