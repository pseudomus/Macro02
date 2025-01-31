//
//  EssayAllResponse.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

// Modelo para EssayAllResponse (modelo de resposta do servidor)
struct EssayAllResponse: Codable {
    let id: Int
    let theme: String
    let content: String
    let creationDate: String
    let tag: String
    let userId: Int
    let title: String
    let Metrics: [MetricsResponse]
    let Competences: [CompetenceResponse]
}
