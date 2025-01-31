//
//  ConvertToEssayResponse.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

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
