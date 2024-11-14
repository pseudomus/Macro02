//
//  TransactionService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//

import StoreKit

// MARK: - SERVICE
class TransactionService: NetworkService {

    // Envia os dados de uma transação para o servidor
    func sendTransactionToServer(transaction: StoreKit.Transaction) async throws {
        guard let url = URL(string: Endpoints.deleteEssay) else {
            throw NetworkError.invalidURL
        }
        
        let transactionData: [String: Any] = [
            "transactionId": transaction.id,
            "originalTransactionId": transaction.originalID,
            "productId": transaction.productID,
            "purchaseDate": transaction.purchaseDate.timeIntervalSince1970
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: transactionData) else {
            throw NetworkError.decodingError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Erro ao enviar a transação: \(error)")
                    continuation.resume(throwing: NetworkError.unknown(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    print("Erro no servidor, status code: \(httpResponse.statusCode)")
                    continuation.resume(throwing: NetworkError.serverError(statusCode: httpResponse.statusCode))
                    return
                }
                
                continuation.resume(returning: ())
            }.resume()
        }
    }

}
