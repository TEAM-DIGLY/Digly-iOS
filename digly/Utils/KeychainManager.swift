//
//  KeychainManager.swift
//  tyte
//
//  Created by 김 형석 on 9/16/24.
//

import Foundation
import Security

enum KeychainError: Error {
    case unknown(OSStatus)
    case notFound
    case encodingError
}

protocol KeychainManagerProtocol {
    func save(token: String, forKey:String,service:String) throws
    func retrieve(forKey: String, service: String) throws -> String
    func delete(forKey: String, service: String) throws
}

class KeychainManager:KeychainManagerProtocol {
    static let shared = KeychainManager() // 싱글톤 유지
    private init() {} // 싱글톤 유지
    
    func getAccessToken() -> String? {
        try? self.retrieve(forKey:"accessToken")
    }
    func getRefreshToken() -> String? {
        try? self.retrieve(forKey:"refreshToken")
    }
    
    func clearToken() {
        try? self.delete(forKey: "accessToken")
        try? self.delete(forKey: "refreshToken")
    }
    
    func getUsername() -> String? {
        UserDefaults.standard.string(forKey: "lastLoggedInUsername")
    }
    
    func getDiglyType() -> String? {
        UserDefaults.standard.string(forKey: "diglyType")
    }
    
    
    
    //MARK: - 핵심 로직
    func save(token: String, forKey key: String, service: String = "com.clip.ddom") throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingError
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, let's update it
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key
            ]
            let updateAttributes: [String: Any] = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
            
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unknown(updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
    
    func retrieve(forKey key: String, service: String = "com.yourapp.tokens") throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.notFound
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data, let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.unknown(status)
        }
        
        return token
    }
    
    func delete(forKey key: String, service: String = "com.yourapp.tokens") throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
}
