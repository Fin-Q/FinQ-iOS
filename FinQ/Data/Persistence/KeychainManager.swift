//
//  KeychainManager.swift
//  FinQ
//
//  Created by 권대윤 on 8/27/26.
//

import Foundation
import Security

protocol KeychainManagerProtocol {
    func saveItem(item: String, forKey key: KeyType) -> Bool
    func getItem(forKey key: KeyType) -> String?
    func deleteItem(forKey key: KeyType) -> Bool
}

enum KeyType: String {
    case accessToken
    case refreshToken
    case userFullName
    case userEmail
}

final class KeychainManager: KeychainManagerProtocol {
    
    static let shared = KeychainManager()
    private init() {}
    
    func saveItem(item: String, forKey key: KeyType) -> Bool {
        guard let data = item.data(using: .utf8) else { return false }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        // 기존 값을 갱신
        let attributes = [
            kSecValueData: data,
            kSecAttrAccessible:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ] as CFDictionary
        
        let updateStatus = SecItemUpdate(
            query,
            attributes
        )
        
        // 기존 값 업데이트 성공
        if updateStatus == errSecSuccess {
            AppLogger.shared.log("키체인 업데이트 성공", level: .debug)
            return true
        }
        
        // 없는 경우에 새로 추가
        if updateStatus == errSecItemNotFound {
            let addQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecAttrAccessible:
                    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                kSecValueData: data
            ] as CFDictionary
            
            let addStatus = SecItemAdd(
                addQuery,
                nil
            )
            
            if addStatus == errSecSuccess {
                AppLogger.shared.log("키체인 저장 성공", level: .debug)
            } else {
                AppLogger.shared.log("키체인 저장 실패: \(SecCopyErrorMessageString(addStatus, nil) as String? ?? "")", level: .error)
            }
            
            return addStatus == errSecSuccess
        }
        
        AppLogger.shared.log("키체인 업데이트 실패: \(SecCopyErrorMessageString(updateStatus, nil) as String? ?? "")", level: .error)
        return false
    }
    
    func getItem(forKey key: KeyType) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data else {
            AppLogger.shared.log("\(SecCopyErrorMessageString(status, nil) as String? ?? "")", level: .error)
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func deleteItem(forKey key: KeyType) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status == errSecSuccess {
            AppLogger.shared.log("키체인 삭제 성공", level: .debug)
        } else {
            print(SecCopyErrorMessageString(status, nil) ?? "")
            AppLogger.shared.log("키체인 삭제 실패: \(SecCopyErrorMessageString(status, nil) as String? ?? "")", level: .error)
        }
        
        return status == errSecSuccess
    }
}
