//
//  EssayService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 22/10/24.
//

import SwiftUI
import Foundation

// Modelo para Competência
struct Competency: Codable {
    let resume: String
    let cards: [Card]
}

// Modelo para Card
struct Card: Codable, Hashable {
    let title: String?
    let element: String?
    let context: String?
    let suggestion: String?
    let message: String?
}

// Modelo para a Resposta
struct EssayResponse: Codable {
    let theme: String
    let title: String
    let tag: String
    let competencies: [Competency]
    let metrics: Metrics
}

// Modelo para Métricas
struct Metrics: Codable {
    let words: Int
    let paragraphs: Int
    let lines: Int
    let connectors: Int
    let deviations: Int
    let citations: Int
    let argumentativeOperators: Int
}


class EssayViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var essayResponse: EssayResponse? // Armazenar a resposta do ensaio

    let essayService: EssayService
    
    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    // FETCH USER DATA
    func sendEssayToCorrection(text: String, title: String, theme: String) {
        isLoading = true
        
        essayService.sendEssayToCorrection(text: text, title: title, theme: theme) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                    
                case .success(let response):
                    self.essayResponse = response // Armazenar a resposta
                    print("Resposta recebida: \(response)")
                    
                case .failure(let failure):
                    let errorMessage = "Erro ao serviço tentar carregar os dados do usuário: \(failure.localizedDescription)"
                    print(errorMessage)
                    
                    self.errorMessage = errorMessage
                }
            }
        }
    }
}

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
            "userId": 34,
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
