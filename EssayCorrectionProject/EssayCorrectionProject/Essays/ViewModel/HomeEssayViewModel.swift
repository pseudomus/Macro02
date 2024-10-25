//
//  HomeEssayViewModel.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 24/10/24.
//

import SwiftUI

class HomeEssayViewModel: ObservableObject {
    @Published var isFirstTime: Bool = false //Define o estado da view sobre as redações corrigidas
    @Published var essays: [EssayAllResponse] = []
    @Published var isLoading = false
    
    let essayService: EssayService
    
    init(container: DependencyContainer = .shared) {
        self.essayService = container.essayService
    }
    
    func fetchEssays(id: String) {
        isLoading = true
        essayService.fetchEssays(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .success(let success):
                    self.essays = success
                    if self.essays.isEmpty {
                        self.isFirstTime = true
                    } else {
                        self.isFirstTime = false
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
}
