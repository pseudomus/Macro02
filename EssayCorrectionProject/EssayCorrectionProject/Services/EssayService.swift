//
//  EssayService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 22/10/24.
//

import SwiftUI
import Foundation


// MARK: - SERVICE
class EssayService: NetworkService {
    
    // MARK: SEND ESSAY TO CORRECTION - POST METHOD
    func sendEssayToCorrection(text: String, title: String, theme: String, completion: @escaping (Result<EssayResponse, NetworkError>) -> Void) {
        
        // Endpoint
        guard let url = URL(string: Endpoints.sendEssayToCorrection) else {
            completion(.failure(.invalidURL))  // URL inválida
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Conteúdo que será enviado
        let body: [String: Any] = [
            "text": text,
            "title": title,
            "theme": theme,
            "lines": 10,
            "words": 10,
            "paragraphs": 10,
            "userId": 101,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // REQUISIÇÃO
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let data = data else {
                print("Nenhum dado recebido")
                completion(.failure(.noData))
                return
            }
            
            do {
                // Decodifica a resposta em um objeto EssayResponse
                let essayResponse = try JSONDecoder().decode(EssayResponse.self, from: data)
                print("Resposta do servidor: \(essayResponse)")
                completion(.success(essayResponse))
            } catch {
                print("Erro ao processar a resposta: \(error)")
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }

}
