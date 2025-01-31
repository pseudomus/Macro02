//
//  Article.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import Foundation

struct Article: Codable {
    let article_id: String
    let title: String
    let source_name: String
    let source_icon: String?
    let pubDate: String
    let category: [String]
    let image_url: String?
    let link: String
}
