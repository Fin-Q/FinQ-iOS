//
//  KeychainManager.swift
//  FinQ
//
//  Created by 권대윤 on 8/27/26.
//

import Foundation
import Security

protocol KeychainManagerProtocol {
    func saveToken(token: String, forKey key: KeyType) -> Bool
    func getToken(forKey key: KeyType) -> String?
    func deleteToken(forKey key: KeyType) -> Bool
}

enum KeyType: String {
    case accessToken
    case refreshToken
}

final class KeychainManager: KeychainManagerProtocol {
    
    static let shared = KeychainManager()
    private init() {}
    
    func saveToken(token: String, forKey key: KeyType) -> Bool {
        guard let data = token.data(using: .utf8) else { return false }
        
        // 기존 토큰을 찾기 위한 쿼리
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        // 기존 토큰이 있으면 갱신할 값
        let attributes = [
            kSecValueData: data,
            kSecAttrAccessible:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ] as CFDictionary
        
        let updateStatus = SecItemUpdate(
            query,
            attributes
        )
        
        // 기존 토큰 업데이트 성공
        if updateStatus == errSecSuccess {
            AppLogger.shared.log("키체인 토큰 업데이트 성공", level: .debug)
            return true
        }
        
        // 토큰이 없는 경우에만 새로 추가
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
                AppLogger.shared.log("키체인 토큰 저장 성공", level: .debug)
            } else {
                AppLogger.shared.log("키체인 토큰 저장 실패: \(SecCopyErrorMessageString(addStatus, nil) as String? ?? "")", level: .error)
            }
            
            return addStatus == errSecSuccess
        }
        
        AppLogger.shared.log("키체인 토큰 업데이트 실패: \(SecCopyErrorMessageString(updateStatus, nil) as String? ?? "")", level: .error)
        return false
    }
    
    func getToken(forKey key: KeyType) -> String? {
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
    
    func deleteToken(forKey key: KeyType) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status == errSecSuccess {
            AppLogger.shared.log("키체인 토큰 삭제 성공", level: .debug)
        } else {
            print(SecCopyErrorMessageString(status, nil) ?? "")
            AppLogger.shared.log("키체인 토큰 삭제 실패: \(SecCopyErrorMessageString(status, nil) as String? ?? "")", level: .error)
        }
        
        return status == errSecSuccess
    }
}
