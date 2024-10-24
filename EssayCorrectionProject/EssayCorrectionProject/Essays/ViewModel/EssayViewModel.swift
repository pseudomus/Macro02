//
//  EssayViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 24/10/24.
//

import SwiftUI

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
