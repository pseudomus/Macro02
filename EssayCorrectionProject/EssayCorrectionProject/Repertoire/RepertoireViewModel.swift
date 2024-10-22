//
//  RepertoireViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//
import SwiftUI

class RepertoireViewModel: ObservableObject {
    @Published var repertories: [Citation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let repertoireService: RepertoireService
    
    init(container: DependencyContainer = .shared) {
        self.repertoireService = container.repertoireService
    }
    
    func fetchRepertoires() {
//        isLoading = true
//        repertoireService.fetchRepertoires { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let repertories):
//                    self?.repertories = repertories
//                case .failure(let error):
//                    self?.errorMessage = "Erro ao carregar artigos: \(error.localizedDescription)"
//                }
//            }
//        }
        
        //DADOS MOCKADOS TEMPORARIAMENTE DEVIDO A INSTABILIDADE DO SERVIDOR
        self.repertories = MockRepertoireService.fetchRepertoires()
    }
    
}
