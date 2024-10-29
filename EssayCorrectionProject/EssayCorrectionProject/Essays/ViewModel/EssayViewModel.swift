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

    private let essayService: EssayService

    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    // FETCH USER DATA
    func sendEssayToCorrection(text: String, title: String, theme: String, userId: Int) {
        isLoading = true
        essayService.sendEssayToCorrection(text: text, title: title, theme: theme, userId: userId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.essayResponse = response
                case .failure(let failure):
                    self.errorMessage = "Erro ao carregar os dados: \(failure.localizedDescription)"
                }
            }
        }
    }
}
