import Foundation
import Security

enum KeychainError: Error {
    case unknown(OSStatus)
    case notFound
    case encodingError
}

enum KeychainKeys {
    static let serviceName = "com.digly.ios"
    
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let fcmToken = "fcmToken"
}

final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func getAccessToken() -> String? {
        do {
            return try retrieve(forKey: KeychainKeys.accessToken)
        } catch {
            print("getAccessToken Error in KeychainManager")
            return nil
        }
    }
    
    func getRefreshToken() -> String? {
        do {
            return try retrieve(forKey: KeychainKeys.refreshToken)
        } catch {
            print("getRefreshToken Error in KeychainManager")
            return nil
        }
    }
    
    func getFcmToken() -> String? {
        do {
            return try retrieve(forKey: KeychainKeys.fcmToken)
        } catch {
            print("getFcmToken Error in KeychainManager")
            return nil
        }
    }
    
    func saveFcmToken(_ fcmToken: String) {
        do {
            try save(token: fcmToken, forKey: KeychainKeys.fcmToken)
        } catch {
            print("Save Fcm Token Error in KeychainManager")
        }
    }
    
    func saveTokens(_ accessToken: String, _ refreshToken: String) {
        do {
            try save(token: accessToken, forKey: KeychainKeys.accessToken)
            try save(token: refreshToken, forKey: KeychainKeys.refreshToken)
        } catch {
            print("Save tokens Error in KeychainManager")
        }
    }
    
    func clearTokens() {
        do {
            try delete(forKey: KeychainKeys.accessToken)
            try delete(forKey: KeychainKeys.refreshToken)
        } catch{
            print("clear token Error in KeychainManager")
        }
    }
    
}

private extension KeychainManager {
    func save(token: String, forKey key: String, service: String = KeychainKeys.serviceName) throws {
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
    
    func retrieve(forKey key: String, service: String = KeychainKeys.serviceName) throws -> String {
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
    
    func delete(forKey key: String, service: String = KeychainKeys.serviceName) throws {
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