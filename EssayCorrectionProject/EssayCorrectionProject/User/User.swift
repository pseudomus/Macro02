//
//  User.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

// MARK: - USER MODEL
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    
    // PROVEDOR DE AUTENTICAÇÃO
    //let authProvider: String // provedor de autenticação (Apple, Google, etc.)
    //let providerUserId: String // ID único fornecido pelo provedor
}
