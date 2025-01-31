//
//  EssayResponse.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

struct EssayResponse: Codable, Identifiable {
    var id: Int? = nil
    let theme: String
    let title: String
    let tag: String
    var content: String? = nil
    var creationDate: String? = nil
    let competencies: [Competency]
    let metrics: Metrics
    var isCorrected: Bool? = true
}
