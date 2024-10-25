//
//  UserService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

import SwiftUI
import Foundation

// MARK: - SERVICE
class UserService: NetworkService {
    
    // MARK: FETCH USER DATA
    func fetchUserData(completion: @escaping (Result<User, NetworkError>) -> Void) {
        // Pegar o token do keychain
        guard let token = KeychainHelper.retrieveJWT() else {
            completion(.failure(.noData))  // Falha ao obter token
            return
        }

        // Endpoint
        guard let url = URL(string: Endpoints.fetchUser) else {
            completion(.failure(.invalidURL))  // URL inválida
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15 // Timeout de 15 segundos

        // Requisição
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError?, error.code == NSURLErrorTimedOut {
                print("A requisição demorou muito.")
                completion(.failure(.timeout)) // Timeout na requisição
                return
            } else if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(.unknown(error))) // Outro erro desconhecido
                return
            }

            // Verificar o status da resposta HTTP
            if let httpResponse = response as? HTTPURLResponse {
                print("Status da resposta: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode))) // Erro no servidor
                    
                    // EXPIROU O TOKEN, DESLOGA O USUÁRIO
                    DispatchQueue.main.async {
                        AuthManager.shared.isAuthenticated = false
                    }
                    
                    return
                }
            }

            // Garantir que há dados
            guard let data = data else {
                print("Nenhum dado recebido.")
                completion(.failure(.noData)) // Nenhum dado recebido
                return
            }

            // Processar a resposta JSON do backend PARA PEGAR APENAS OS CAMPOS QUE QUERO E CONSTRUIR UM MODELO NO APP
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userDict = json["user"] as? [String: Any] {

                    // Extrair os dados do usuário
                    if let id = userDict["id"] as? Int,
                       let name = userDict["displayName"] as? String,
                       let email = userDict["email"] as? String {

                        let user = User(id: id, name: name, email: email)
                        completion(.success(user)) // Devolver o usuário para a ViewModel
                    } else {
                        completion(.failure(.decodingError)) // Erro ao decodificar campos do JSON
                    }
                } else {
                    completion(.failure(.decodingError)) // JSON mal formatado
                }
            } catch {
                print("Erro ao processar a resposta: \(error)")
                completion(.failure(.decodingError)) // Erro de parsing do JSON
            }
        }
        .resume()
    }
    
    // MARK: LOGIN - POST METHOD
    func login(provider: String, token: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: Endpoints.login) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Conteúdo que será enviado
        let body: [String: Any] = [
            "provider": provider,
            "name": name,
            "token": token
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        print("Requisição de login enviada com token: \(token)")
        
        // REQUISIÇÃO DE LOGIN
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Nenhum dado recebido")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Resposta JSON completa do backend
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    print("Resposta do servidor: \(json)")
                    // CAMPOS DA RESPOSTA
                    if let token = json["token"] as? String, let userDict = json["user"] as? [String: Any] {
                        print("Token recebido: \(token)")
                        
                        // EXTRAIR CAMPOS QUE QUEREMOS DO USUÁRIO
                        if let id = userDict["id"] as? Int,
                           let name = userDict["displayName"] as? String,
                           let email = userDict["email"] as? String {
                            
                            // LOGA O USUÁRIO
                            AuthManager.shared.loginWithToken(token)
                            let user = User(id: id, name: name, email: email)
                            completion(.success(user)) // Devolve o usuário para a ViewModel
                        }
                    }
                }
            } catch {
                print("Erro ao processar a resposta: \(error)")
                completion(.failure(error))
            }
        }
        .resume()
    }
}

