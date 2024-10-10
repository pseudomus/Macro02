//
//  KeychainHelper.swift
//  MacroBackendStudies
//
//  Created by Leonardo Mota on 30/09/24.
//

// MARK: - KEYCHAIN MANAGER
import Security
import Foundation

class KeychainHelper {
    
    static let tokenKey = "userAuthToken"
    
    // Salvar JWT no Keychain
    static func saveJWT(token: String) {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // remove entradas duplicadas
        SecItemAdd(query as CFDictionary, nil)
    }
    
    // Recuperar JWT do Keychain
    static func retrieveJWT() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // Remover JWT do Keychain (Logout)
    static func deleteJWT() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
