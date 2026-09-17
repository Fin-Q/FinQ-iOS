//
//  NotificationSettingUpdateRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

struct NotificationSettingUpdateRequest: Encodable, Sendable {
    let notificationEnabled: Bool
}
