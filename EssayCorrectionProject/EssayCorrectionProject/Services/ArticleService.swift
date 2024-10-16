//
//  ArticleService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 15/10/24.
//

import Foundation

class ArticleService: NetworkService {
    func fetchArticles(completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        guard let url = URL(string: Endpoints.articles) else {
            completion(.failure(.invalidURL))  // URL inválida
            return
        }
        
        // chamada de rede
        request(url: url, completion: completion)
    }
}
