//
//  EssayViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 24/10/24.
//

import SwiftUI

class EssayViewModel: ObservableObject {
    @Published var essays: [EssayResponse] = []
    @Published var isFirstTime: Bool = false
    @Published var isLoading = false
    @Published var shouldFetchEssays: Bool = false
    @Published var errorMessage: String?
    @Published var essayResponse: EssayResponse?

    private let essayService: EssayService
    
    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    // MARK: - FETCH DE TODAS AS REDAÇÕES
    func fetchEssays(userId: String) {
        guard !isLoading else { return }
        
        isLoading = true
        essayService.fetchEssays(id: userId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let essays):
                    self.essays = essays
                    self.isFirstTime = essays.isEmpty
                case .failure(let error):
                    self.errorMessage = "Erro ao buscar redações: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - ENVIAR PARA CORREÇÃO
    func sendEssayToCorrection(text: String, title: String, theme: String, userId: Int) {
        isLoading = true
        
        // Cria uma resposta temporária e adiciona à lista de redações
        let temporaryEssayResponse = EssayResponse(
            theme: theme,
            title: "Carregando...",
            tag: "",
            competencies: [],
            metrics: Metrics(words: 0, paragraphs: 0, lines: 0, connectors: 0, deviations: 0, citations: 0, argumentativeOperators: 0)
        )
        
        // Adiciona o card temporário à lista
        essays.append(temporaryEssayResponse)
        
        essayService.sendEssayToCorrection(text: text, title: title, theme: theme, userId: userId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    //self.essayResponse = response
                    // atualiza a redação com a resposta final e remove o temporário
                    if let index = self.essays.firstIndex(where: { $0.title == "Carregando..." }) {
                        self.essays[index] = response // Atualiza o card temporário com a resposta final
                    }
                    self.shouldFetchEssays = true
                case .failure(let error):
                    // Remove o card temporário se ocorrer erro
                    self.essays.removeAll(where: { $0.title == "Carregando..." })
                    self.errorMessage = "Erro ao enviar redação: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteEssay(withId id: String) {
        isLoading = true
        essayService.deleteEssay(withId: id) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    self.shouldFetchEssays = true
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
}
