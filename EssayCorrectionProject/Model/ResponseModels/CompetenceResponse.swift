//
//  CompetenceFailure2.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

// Modelo para CompetenceResponse
struct CompetenceResponse: Codable {
    let id: Int
    let compositionId: Int
    let competence_resume: String
    let Cards: [CardResponse]
}
