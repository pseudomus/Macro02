//
//  UserViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

import Foundation

// MARK: - VIEWMODEL USUÁRIO
class UserViewModel: ObservableObject {
    @Published var user: User? // Modelo de usuário
    @Published var errorMessage: String?
    @Published var isLoading = false

    let userService: UserService

    init(container: DependencyContainer = .shared) {
        self.userService = container.userservice
    }
    
    // FETCH USER DATA
    func fetchUserData() {
        isLoading = true
        
        userService.fetchUserData { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                    
                case .success(let user):
                    print("Usuário carregado: \(user)")
                    self.user = user
                    
                case .failure(let failure):
                    let errorMessage = "Erro ao serviço tentar carregar os dados do usuário: \(failure.localizedDescription)"
                    print(errorMessage)
                    
                    self.user = nil
                    self.errorMessage = errorMessage
                }
            }
        }
    }
    
    
    // LOGIN / CADASTRO - BUSCAR DADOS AO ENTRAR NO APP
    func login(withProvider provider: String, token: String, name: String) {
        isLoading = true
        
        userService.login(provider: provider, token: token, name: name) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                    
                case .success(let user):
                    print("Login feito com sucesso: \(user)")
                    self.user = user
                    
                case .failure(let failure):
                    self.errorMessage = "Erro ao serviço tentar fazer login: \(failure.localizedDescription)"
                    self.user = nil 
                }
            }
        }
    }
}
