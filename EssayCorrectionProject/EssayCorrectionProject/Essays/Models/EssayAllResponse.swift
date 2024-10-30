//
//  EssayAllResponse.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 24/10/24.
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

// Modelo para CompetenceResponse
struct CompetenceResponse: Codable {
    let id: Int
    let compositionId: Int
    let competence_resume: String
    let Cards: [CardResponse]
}

// Modelo para MetricsResponse
struct MetricsResponse: Codable {
    let id: Int
    let compositionId: Int
    let words: Int
    let paragraphs: Int
    let lines: Int
    let connectors: Int
    let deviations: Int
    let citations: Int
    let argumentativeOperators: Int
}

func convertToEssayResponse(_ essayAllResponse: EssayAllResponse) -> EssayResponse {
    // Métricas
    let metricsData = essayAllResponse.Metrics.first!
    let metrics = Metrics (
        words: metricsData.words,
        paragraphs: metricsData.paragraphs,
        lines: metricsData.lines,
        connectors: metricsData.connectors,
        deviations: metricsData.deviations,
        citations: metricsData.citations,
        argumentativeOperators: metricsData.argumentativeOperators
    )
    
    // Competencias
    let competencies = essayAllResponse.Competences.map { competenceResponse in
        let cards = competenceResponse.Cards.map { cardResponse in
            Card(
                title: cardResponse.resumo_do_card,
                element: cardResponse.error,
                context: cardResponse.context,
                suggestion: cardResponse.suggestion,
                message: cardResponse.message
            )
        }
        return Competency(
            resume: competenceResponse.competence_resume,
            cards: cards
        )
    }
    
    // ESSAY RESPONSE FINAL
    return EssayResponse(
        id: essayAllResponse.id,
        theme: essayAllResponse.theme,
        title: essayAllResponse.title,
        tag: essayAllResponse.tag,
        content: essayAllResponse.content,
        creationDate: essayAllResponse.creationDate,
        competencies: competencies,
        metrics: metrics
    )
}
