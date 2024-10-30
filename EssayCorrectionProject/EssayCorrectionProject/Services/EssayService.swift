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
    func sendEssayToCorrection(text: String, title: String, theme: String, userId: Int, completion: @escaping (Result<EssayResponse, NetworkError>) -> Void) {
        
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
            "userId": userId,
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
                print("Erro ao processar a resposta1: \(error)")
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }
    
    // MARK: FETCH USER ESSAYS - POST METHOD
    func fetchEssays(id: String, completion: @escaping (Result<[EssayResponse], NetworkError>) -> Void) {
        guard let url = URL(string: Endpoints.allEssays) else {
            completion(.failure(.invalidURL))  // URL inválida
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Conteúdo que será enviado
        let body: [String: Any] = [
            "userId": id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
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
                let essayAllResponses = try JSONDecoder().decode([EssayAllResponse].self, from: data)
                let essayResponses = essayAllResponses.map { convertToEssayResponse($0) }
                completion(.success(essayResponses))
            } catch {
                print("Erro ao processar a resposta2: \(error)")
                completion(.failure(.decodingError))
            }
        }
        .resume()
        
    }
    
    // MARK: - DELETE ESSAY - POST METHOD
    func deleteEssay(withId id: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: "\(Endpoints.deleteEssay)/\(id)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                completion(.success(()))
            case 404:
                completion(.failure(.serverError(statusCode: 404)))
            default:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }
        }
        task.resume()
    }


}
