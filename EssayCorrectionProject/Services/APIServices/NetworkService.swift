//
//  Service.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

import Foundation

// MARK: - GERERIC SERVICE
class NetworkService {
    
    func request<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // VERIFICAR ERROS
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            // VERIFICAR STATUS DA RESPOSTA
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError(statusCode: 0)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            // DECODIFICAR DADOS
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
