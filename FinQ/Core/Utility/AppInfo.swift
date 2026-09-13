//
//  AppInfo.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import UIKit

enum AppInfo {
    @MainActor
    static func getDeviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
