//
//  DependencyContainer.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

// CLASSE PARA INICIALIZAR TODOS OS SERVICES
class DependencyContainer {
    static var shared = DependencyContainer()
    
    let userservice = UserService()
    let articleService = ArticleService()
    let repertoireService = RepertoireService()
}
