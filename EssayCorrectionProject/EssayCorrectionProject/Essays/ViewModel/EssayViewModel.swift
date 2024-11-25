//
//  EssayViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 24/10/24.
//

import SwiftUI

class EssayViewModel: ObservableObject {
    
    //DADOS PARA A HOMEVIEW
    @Published var groupedEssays: [String: [EssayResponse]] = [:]
    @Published var sortedMonths: [String] = []

    //DADOS TEMPORARIOS PARA O FLUXO DE CORREÇÃO
    @Published var correctionMode: CorrectionMode = .none
    @Published var text: String = ""
    @Published var title: String = ""
    @Published var theme: String = ""
    @Published var scannedImage: UIImage?
    @Published var transcription: Transcription?
    @Published var isTranscriptionReady: Bool = false
    @Published var transcriptionError: Bool = false
    @Published var fullTranscribedText: String = ""
    
    @Published var errorMessage: String?
    @Published var essays: [EssayResponse] = [] {
        didSet {
            self.updateGroupedEssaysAndMonths()
        }
    }
    @Published var isFirstTime: Bool = true
    @Published var isLoading = false
    @Published var shouldFetchEssays: Bool = false
    @Published var essayResponse: EssayResponse?
    @Published var failures: [CompetenceFailure] = Array(repeating: CompetenceFailure(errorsCount: 1, competency: 1), count: 5)

    private let essayService: EssayService
    let transcriptionService = TranscriptionService()
    
    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    func getCount() -> Int {
        return essays.count
    }
    
    func getNumbersOfEssayErrors() {
        var array: [[Int]] = Array(repeating: [], count: 5)
        
        print(essays.count)
        
        for essay in essays {
            for n in 0..<array.count {
                if n < essay.competencies.count {
                    array[n].append(essay.competencies[n].cards.count)
                }
            }
        }
        
        var transformedArray: [CompetenceFailure] = []
        
        for n in 0..<array.count {
            transformedArray.append(CompetenceFailure(errorsCount: array[n].reduce(0, +), competency: n + 1))
        }
        
        print(transformedArray)
        
        failures = transformedArray
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
    
    func logout() {
        self.essays.removeAll()
        self.shouldFetchEssays = true
        
    }
    
    //MARK: - ORGANIZACAO DAS REDACOES
    
    
    private func updateGroupedEssaysAndMonths() {
        // Cache grouped essays
        let essaysWithValidDate = essays.filter { $0.creationDate != nil }
        let grouped = Dictionary(grouping: essaysWithValidDate, by: { monthYear(from: $0.creationDate ?? "") })
             groupedEssays = grouped.mapValues {
            $0.sorted {
                guard let date1 = dateFromString($0.creationDate!), let date2 = dateFromString($1.creationDate!) else { return false }
                return date1 > date2
            }
        }

        // Cache sorted months
        sortedMonths = groupedEssays.keys.sorted {
            guard let date1 = dateFromMonthYear($0), let date2 = dateFromMonthYear($1) else { return false }
            return date1 > date2
        }
        
        getNumbersOfEssayErrors()
    }
    
    private func monthYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Data Inválida"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM 'de' yyyy"
        outputFormatter.locale = Locale(identifier: "pt_BR")
        return outputFormatter.string(from: date).capitalized
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)
    }
    
    private func dateFromMonthYear(_ monthYear: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM 'de' yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.date(from: monthYear)
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
        isFirstTime = false
        
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
                    self.essays.removeAll {
                        if let essayId = $0.id { return String(essayId) == id }
                        return false
                    }
                    self.shouldFetchEssays = true
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
    func getTopEssayMistakes(in responses: [EssayResponse]) -> [(title: String, averageCount: Int)] {

        var titleCounts: [String: Int] = [:]
        
        for response in responses {
            for competency in response.competencies {
                for card in competency.cards {

                    if let title = card.title {

                        titleCounts[title, default: 0] += 1
                    }
                }
            }
        }
        
        let totalResponses = responses.count
        
        let averageTitleCounts = titleCounts.mapValues { count in
            return count / totalResponses
        }
        
        let topThree = averageTitleCounts.sorted(by: { $0.value > $1.value })
                                          .prefix(3)
                                          .map { (title: $0.key, averageCount: $0.value) }
        
        return topThree
    }

}
