//
//  NewsViewModel2.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import Foundation

public class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let articleService: ArticleService
    
    init(container: DependencyContainer = .shared) {
        self.articleService = container.articleService
        self.fetcharticles()
    }
    
    func fetcharticles()  {
        isLoading = true
        articleService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let articles):
                    self?.articles = articles
                case .failure(let error):
                    self?.errorMessage = "Erro ao carregar artigos: \(error.localizedDescription)"
                }
            }
        }
    }
}
