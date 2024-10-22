//
//  RepertoireService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//

import Foundation

//class MockRepertoireService: RepertoireService {
//    func fetchRepertoires(completion: @escaping (Result<[Repertoire], NetworkError>) -> Void) {
//        let repertoire: [Repertoire] = []
//    }
//}

class RepertoireService: NetworkService {
    func fetchRepertoires(completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        guard let url = URL(string: Endpoints.articles) else {
            completion(.failure(.invalidURL))
            return
        }
        
        request(url: url, completion: completion)
    }
}

struct Repertoire: Codable {
    let article_id: String
    let title: String
    let source_name: String
    let source_icon: String?
    let pubDate: String
    let category: [String]
    let image_url: String?
    let link: String
}
