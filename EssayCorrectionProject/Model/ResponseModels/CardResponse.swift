//
//  CardResponse.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

// Modelo para CardResponse
struct CardResponse: Codable {
    let id: Int
    let competence_id: Int
    let resumo_do_card: String
    let error: String?
    let context: String?
    let suggestion: String?
    let message: String?
}
