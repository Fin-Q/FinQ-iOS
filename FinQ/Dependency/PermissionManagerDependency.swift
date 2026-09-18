//
//  PermissionManagerDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

private enum PermissionManagerKey: DependencyKey {
    static let liveValue: any PermissionManagerProtocol = PermissionManager.shared
}

extension DependencyValues {
    var permissionManager: any PermissionManagerProtocol {
        get { self[PermissionManagerKey.self] }
        set { self[PermissionManagerKey.self] = newValue }
    }
}
