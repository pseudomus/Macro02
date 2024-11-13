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

struct NewsNavigationStackView: View {
    
    @State var baseRouter: [BaseRoute] = []
    @Environment(\.navigate) var navigate
    
    var body: some View {
        NavigationStack (path: $baseRouter){
            NewsView()
                .navigationDestination(for: BaseRoute.self) { node in
                    node.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            if case .profile = route {
                baseRouter.append(BaseRoute.profile)
            } else if route == .back && baseRouter.count >= 1 {
                baseRouter.removeLast()
            }
        }))
    }
}

struct NewsView: View {
    @StateObject private var viewModel = ArticleViewModel() 
    @State private var selectedFilters: Set<String> = []

    // Dicionário para traduzir as categorias
    private let categoryTranslations: [String: String] = [
        "business": "Negócios",
        "entertainment": "Entretenimento",
        "environment": "Meio ambiente",
        "food": "Culinária",
        "health": "Saúde",
        "politics": "Política",
        "science": "Ciência",
        "sports": "Esporte",
        "technology": "Tecnologia",
        "world": "Mundo",
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if viewModel.isLoading {
                    ProgressView("Carregando artigos...") // indicador de carregamento
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage) // exibir mensagem de erro
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    CustomHeaderView(
                        showCredits: false,
                        title: "Notícias",
                        filters: uniqueCategories(from: viewModel.articles), // pegando categorias únicas
                        showFiltersBeforeSwipingUp: true,
                        distanceContentFromTop: 120,
                        showSearchBar: false,
                        isScrollable: true,
                        numOfItems: viewModel.articles.count,
                        onSelectFilter: { filter in
                            toggleFilter(filter) // alternar seleção de filtros
                        }
                    ) { _ in
                        LazyVStack(spacing: 30) {
                            ForEach(filteredArticles, id: \.article_id) { article in
                                NewsCardView(
                                    title: article.title,
                                    date: formattedDate(article.pubDate),
                                    imageUrl: article.image_url,
                                    link: article.link,
                                    proxy: proxy
                                )
                                .frame(height: proxy.size.height / 3)
                            }
                        }
                        .padding(.bottom, 100) // para tabbar nao cobrir
                        .background(.clear)
                    }
                }
            }.background(.colorBgPrimary)
            .onAppear {
                viewModel.fetcharticles()
            }
        }
    }
    
    // OBTER CATEGORIAS DOS FILTROS (Traduzindo as categorias)
    func uniqueCategories(from articles: [Article]) -> [String] {
        let allCategories = articles.flatMap { $0.category }
        let uniqueCategories = Array(Set(allCategories)).sorted()
        // remover o "top" - api problemas
        let filteredCategories = uniqueCategories.filter { $0 != "top" }
        return filteredCategories.map { translateCategory($0) }
    }

    
    // traduzir a categoria
    func translateCategory(_ category: String) -> String {
        let translated = categoryTranslations[category, default: category.capitalized]
        return translated
    }

    
    // formatar a data
    func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = formatter.date(from: dateString) else {
            return "Data inválida"
        }
        
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    // FILTRAR
    var filteredArticles: [Article] {
        if selectedFilters.isEmpty {
            return viewModel.articles
        } else {
            return viewModel.articles.filter { article in
                selectedFilters.intersection(Set(article.category.map { translateCategory($0) })).count > 0
            }
        }
    }
    
    // Alternar seleção de filtros
    private func toggleFilter(_ filter: String) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter) // se já está selecionado, remove
        } else {
            selectedFilters.insert(filter) // se não está selecionado, adiciona
        }
    }
}

struct NewsCardView: View {
    var title: String
    var date: String
    var imageUrl: String?
    var link: String
    var validLink: URL? { // verifica se é valido o link
        return URL(string: link)
    }
    
    var proxy: GeometryProxy

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Base do Card
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.colorBgSecondary)
                
                // Conteúdo
                VStack(alignment: .leading, spacing: 10) {
                    // Imagem usando AsyncImage
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75) // Largura do card
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6)))
                                .clipped()
                        } placeholder: {
                            // Placeholder enquanto a imagem carrega
                            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                                .foregroundStyle(.gray)
                                .overlay { ProgressView() }
                                .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75) // Largura do card
                        }
                    } else {
                        // Placeholder se não houver URL
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                            .foregroundStyle(.backgroundBlue)
                            .overlay {
                                Image(.lapisinho) // Ícone padrão como placeholder
                                    .resizable() // Permite redimensionar a imagem
                                    .scaledToFit() // Mantém a proporção da imagem
                                    .foregroundColor(.white.opacity(0.6))
                                        
                            }
                            .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75)
                    }

                    // TEXTOS E PIN
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(title)
                                .fontWeight(.bold)
                            Text(date)
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "pin")
                            .font(.title2)
                            .foregroundStyle(.colorBrandPrimary700)
                    }
                }
                .padding(10)
            }
            .onTapGesture {
                if let validLink = validLink { UIApplication.shared.open(validLink) }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NewsView()
        .environmentObject(StoreKitManager())
}
