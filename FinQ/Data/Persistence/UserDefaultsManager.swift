//
//  UserDefaultsManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/17/26.
//

import UIKit

@propertyWrapper
struct UserDefaultsPropertyWrapper<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults
    
    var wrappedValue: T {
        get {
            return self.storage.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            return self.storage.set(newValue, forKey: self.key)
        }
    }
}

@MainActor
final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    enum Key: String {
        case isFirstLaunch
    }
    
    @UserDefaultsPropertyWrapper(key: Key.isFirstLaunch.rawValue, defaultValue: nil, storage: UserDefaults.standard)
    var isFirstLaunch: Bool?
    
    func removeItem(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
