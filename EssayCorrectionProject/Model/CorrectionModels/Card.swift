//
//  Card.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import Foundation

// Modelo para Card
struct Card: Codable, Hashable {
    let title: String?
    let element: String?
    let context: String?
    let suggestion: String?
    let message: String?
}
