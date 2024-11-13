//
//  RepertoireService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//

import Foundation

class RepertoireService: NetworkService {
    func fetchRepertoires(completion: @escaping (Result<[Repertoire], NetworkError>) -> Void) {
        guard let url = URL(string: Endpoints.repertoire) else {
            completion(.failure(.invalidURL))
            return
        }
                
        request(url: url, completion: completion)
    }
}

struct Repertoire: Codable {
    let repertoire_id: String
    let id: Int
    let author: String
    let text: String
    let theme: Theme
}

enum Theme: String, Codable, CaseIterable {
    case culture = "culture"
    case economy = "economy"
    case education = "education"
    case nature = "nature"
    case politics = "politics"
    case rights = "rights"
    case science = "science"
    case technology = "technology"
    
    static func getArray() -> [String] {
        let filter = Theme.allCases
        return filter.map(\.rawValue)
    }
    
    func verifyIfStringAPIRequestIsPartOfFilter(_ string: String) -> Bool {
        return rawValue.contains(string)
    }
}
