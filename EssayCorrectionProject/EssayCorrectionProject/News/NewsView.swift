//
//  NewsView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 11/10/24.
//

import SwiftUI

// MODEL
struct Article: Codable {
    let article_id: String
    let title: String
    let source_name: String
    let source_icon: String?
    let pubDate: String
    let category: [String]
    let image_url: String?
    let link: String
    
}

// VIEWMODEL
class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let articleService: ArticleService
    
    init(container: DependencyContainer = .shared) {
        self.articleService = container.articleService
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


struct NewsView: View {
    @StateObject private var viewModel = ArticleViewModel() // Observando a ViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if viewModel.isLoading {
                    ProgressView("Carregando artigos...") // Indicador de carregamento
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage) // Exibir mensagem de erro
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    CustomHeaderView(
                        title: "Notícias",
                        filters: uniqueCategories(from: viewModel.articles), // Pegando categorias únicas
                        distanceContentFromTop: 50,
                        showSearchBar: false,
                        isScrollable: true,
                        numOfItems: viewModel.articles.count
                    ) { _ in
                        VStack(spacing: 30) {
                            ForEach(viewModel.articles, id: \.article_id) { article in
                                NewsCardView(
                                    title: article.title,
                                    date: formattedDate(article.pubDate),
                                    imageUrl: article.image_url
                                )
                                .frame(height: proxy.size.height / 3)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetcharticles()
            }
        }
    }
    
    // Função para obter categorias únicas
    func uniqueCategories(from articles: [Article]) -> [String] {
        // Usando Set para eliminar duplicatas
        let allCategories = articles.flatMap { $0.category }
        return Array(Set(allCategories)).sorted() // Convertendo de volta para array ordenado
    }
    
    // Função para formatar a data de String para String
    func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // O formato original da string
        
        guard let date = formatter.date(from: dateString) else {
            return "Data inválida" // Retornar mensagem se a data for inválida
        }
        
        // Formatando a data para o formato desejado
        formatter.dateFormat = "dd/MM/yyyy" // Formato desejado para exibição
        return formatter.string(from: date)
    }

}


struct NewsCardView: View {
    var title: String = "Título da notícia"
    var date: String = "11/10/24"
    var imageUrl: String? // Adicionando uma propriedade para a URL da imagem
    
    var body: some View {
        GeometryReader { proxy in
            // CARD
            ZStack(alignment: .top) {
                // Base
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray.opacity(0.5))
                
                // Imagem e textos
                VStack(alignment: .leading, spacing: 10) {
                    // Imagem usando AsyncImage
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6)))
                        } placeholder: {
                            // Placeholder enquanto a imagem carrega
                            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                                .foregroundStyle(.gray)
                        }
                        .frame(height: proxy.size.height * 0.4) 
                    } else {
                        // Placeholder se não houver URL
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                            .foregroundStyle(.gray)
                            .frame(height: proxy.size.height * 0.4)
                    }
                    
                    // TEXTOS E PIN
                    HStack {
                        VStack (alignment: .leading) {
                            Text(title)
                                .fontWeight(.bold)
                            Text(date)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "pin")
                            .font(.title2)
                    }
                }
                .padding(10)
            }
            .padding(.horizontal)
        }
    }
}




#Preview {
    NewsCardView()
}

#Preview {
    NewsView()
}
