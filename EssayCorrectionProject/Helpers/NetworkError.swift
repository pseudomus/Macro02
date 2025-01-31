//
//  NetworkError.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case timeout
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "A URL fornecida é inválida."
        case .noData:
            return "Nenhum dado foi retornado pela requisição."
        case .decodingError:
            return "Erro ao decodificar a resposta do servidor."
        case .serverError(let statusCode):
            return "Erro do servidor. Código: \(statusCode)"
        case .timeout:
            return "A requisição demorou muito para responder."
        case .unknown(let error):
            return "Erro desconhecido: \(error.localizedDescription)"
        }
    }
}
