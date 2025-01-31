//
//  RepertoireViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//
import SwiftUI
import SwiftData

typealias ID = String

class RepertoireViewModel: ObservableObject {
    @Published var repertories: [Repertoire] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var fixedRepertoires: [ID] = []
    
    let repertoireService: RepertoireService
    
    init(container: DependencyContainer = .shared) {
        self.repertoireService = container.repertoireService
    }
    
    func verifyIfIsPinned(id: ID) -> Bool{
        if (fixedRepertoires.contains(id)) {
            fixedRepertoires.removeAll(where: {$0 == id})
//            print(fixedRepertoires)
            return false
        } else {
            fixedRepertoires.append(id)
//            print(fixedRepertoires)
            return true
        }
    }
    
    func fetchRepertoires() {
        isLoading = true
        repertoireService.fetchRepertoires { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let repertories):
                    self?.repertories = repertories
                case .failure(let error):
                    self?.errorMessage = "Erro ao carregar repertórios: \(error.localizedDescription)"
                }
            }
        }
        
        //DADOS MOCKADOS TEMPORARIAMENTE DEVIDO A INSTABILIDADE DO SERVIDOR
//        self.repertories = MockRepertoireService.fetchRepertoires()
    }
    
}
