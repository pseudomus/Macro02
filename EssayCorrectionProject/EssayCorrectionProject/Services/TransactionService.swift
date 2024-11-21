//
//  TransactionService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//

import StoreKit

// MARK: - SERVICE
class TransactionService: NetworkService {

    // FETCH HISTÓRICO DE COMPRAS
    func fetchTransactionHistory(originalTransactionId: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(Endpoints.baseURL)/transaction/history/\(originalTransactionId)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erro ao buscar histórico de transações: \(error)")
                    continuation.resume(throwing: NetworkError.unknown(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                      let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    continuation.resume(throwing: NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500))
                    return
                }

                continuation.resume(returning: json)
            }.resume()
        }
    }

    
    // Envia os dados de uma transação para o servidor
    func sendTransactionToServer(transaction: StoreKit.Transaction, userId: Int) async throws {
        guard let url = URL(string: Endpoints.sendTransaction) else {
            throw NetworkError.invalidURL
        }

        let transactionData: [String: Any] = [
            "transactionId": transaction.id,
            "productId": transaction.productID,
            "userId": userId
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: transactionData) else {
            throw NetworkError.decodingError
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erro ao enviar transação: \(error)")
                    continuation.resume(throwing: NetworkError.unknown(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                      let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                    print("Erro do servidor com status code: \(statusCode)")
                    continuation.resume(throwing: NetworkError.serverError(statusCode: statusCode))
                    return
                }

                // Processa e imprime a resposta do servidor
                print("Resposta do servidor: \(json)")
                continuation.resume()
            }.resume()
        }
    }

    // Função para carregar o saldo de créditos do servidor
    func getCreditBalance(userId: Int) async throws -> Int {
        guard let url = URL(string: "\(Endpoints.baseURL)/transaction/credits/\(userId)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verifica se a resposta foi bem-sucedida
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: -1) // Caso não seja um HTTPURLResponse
        }

        // Se o status code não estiver entre 200 e 299, lança um erro com o status code exato
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // Processa a resposta JSON
        do {
            // A resposta tem a chave "credits"
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let credits = jsonObject["credits"] as? Int {
                return credits
            } else {
                throw NetworkError.noData
            }
        } catch {
            throw NetworkError.decodingError
        }
    }


}
