//
//  EssayAllResponse.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 24/10/24.
//

import Foundation

struct EssayAllResponse: Codable {
    let id: Int
    let theme, content, creationDate, tag: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id, theme, content, creationDate, tag
        case title
    }
}
