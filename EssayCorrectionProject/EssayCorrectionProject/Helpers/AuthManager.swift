//
//  AuthManager.swift
//  MacroBackendStudies
//
//  Created by Leonardo Mota on 30/09/24.
//

import Foundation

// MARK: - AUTH MANAGER
class AuthManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = AuthManager()

    @Published var isAuthenticated = false
    
    private init() {
        checkAuthentication()
    }
    
    // MARK: - Methods
    func checkAuthentication() {
        if let _ = KeychainHelper.retrieveJWT() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    func logout() {
        KeychainHelper.deleteJWT()
        isAuthenticated = false
    }
    
    func loginWithToken(_ token: String) {
        // salvar o token no Keychain
        print("salvando token no Keychain: \(token)")
        KeychainHelper.saveJWT(token: token)
        DispatchQueue.main.async {
            self.isAuthenticated = true
        }
        
    }
}

