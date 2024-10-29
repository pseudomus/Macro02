//
//  Competency.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 24/10/24.
//


import SwiftUI
import Foundation

// Modelo para a Resposta
struct EssayResponse: Codable, Identifiable {
    var id: Int? = nil
    let theme: String
    let title: String
    let tag: String
    var content: String? = nil
    var creationDate: String? = nil
    let competencies: [Competency]
    let metrics: Metrics
}

// Modelo para Competência
struct Competency: Codable {
    let resume: String
    let cards: [Card]
}

// Modelo para Card
struct Card: Codable, Hashable {
    let title: String?
    let element: String?
    let context: String?
    let suggestion: String?
    let message: String?
}

// Modelo para Métricas
struct Metrics: Codable {
    let words: Int
    let paragraphs: Int
    let lines: Int
    let connectors: Int
    let deviations: Int
    let citations: Int
    let argumentativeOperators: Int
}





