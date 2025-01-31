//
//  MetricsResponse.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

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
