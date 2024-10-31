//
//  EssayViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 24/10/24.
//

import SwiftUI

class EssayViewModel: ObservableObject {

    //DADOS TEMPORARIOS PARA O FLUXO DE CORREÇÃO
    @Published var correctionMode: CorrectionMode = .none
    @Published var text: String = ""
    @Published var title: String = ""
    @Published var theme: String = ""
    @Published var scannedImage: UIImage?
    @Published var transcription: Transcription?
    @Published var isTranscriptionReady: Bool = false
    @Published var fullTranscribedText: String = ""
    
    
    @Published var errorMessage: String?
    @Published var essays: [EssayResponse] = []
    @Published var isFirstTime: Bool = false
    @Published var isLoading = false
    @Published var shouldFetchEssays: Bool = false
    @Published var essayResponse: EssayResponse?

    private let essayService: EssayService
    let transcriptionService = TranscriptionService()
    
    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    func getCount() -> Int {
        return essays.count
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
            title: title,
            tag: "",
            content: text,
            competencies: [],
            metrics: Metrics(words: 0, paragraphs: 0, lines: 0, connectors: 0, deviations: 0, citations: 0, argumentativeOperators: 0),
            isCorrected: false
        )
        
        // adiciona o card temporário à lista
        essays.append(temporaryEssayResponse)
        print("DEBUG: sendessay")

        essayService.sendEssayToCorrection(text: text, title: title, theme: theme, userId: userId) { [weak self] result in
            print("DEBUG: CLOSURE")
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    // Atualiza a redação com a resposta final e remove o temporário
                    if let index = self.essays.firstIndex(where: { $0.isCorrected == false }) {
                        self.essays[index] = response // Atualiza o card temporário com a resposta final
                    }
                    self.essayResponse = response
                    self.shouldFetchEssays = true
                    print("DEBUG: sucesso correcao")
                case .failure(let error):
                    // Remove o card temporário se ocorrer erro
                    self.essays.removeAll(where: { $0.isCorrected == false })
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
