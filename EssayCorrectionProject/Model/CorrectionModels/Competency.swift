//
//  Competency.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

// Modelo para Competência
struct Competency: Codable {
    let resume: String
    let cards: [Card]
}
