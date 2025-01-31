//
//  NewsView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 11/10/24.
//

import SwiftUI
import  Combine

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedFilters: Set<String> = []
    @State var isFixedTabOpen: Bool = false
    //Essa variável controla o intervalo em que os adds aparecem
    private let adInterval: Int = 5
    
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
                
                CustomHeaderView(
                    showCredits: false,
                    title: "Notícias",
                    filters: uniqueCategories(from: viewModel.articles),
                    showFilters: uniqueCategories(from: viewModel.articles),// pegando categorias únicas
                    showFiltersBeforeSwipingUp: true,
                    distanceContentFromTop: 100,
                    showSearchBar: false,
                    isScrollable: true,
                    numOfItems: viewModel.articles.count,
                    onSelectFilter: { filter in
                        toggleFilter(filter) // alternar seleção de filtros
                    }
                ) { _ in
                    VStack {
                        
                        Button {
                            isFixedTabOpen.toggle()
                        } label: {
                            HStack{
                                Text("Fixados")
                                    .font(.title2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .rotationEffect(.degrees(isFixedTabOpen ? 90 : 0))
                                    .animation(.spring, value: isFixedTabOpen)
                            }.padding(.horizontal)
                                .foregroundStyle(.black)
                            
                        }.buttonStyle(.plain)
                        
                        VStack{
                            
                        }.frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .background(Color.black)
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        LazyVStack(spacing: 40) {
                            
                            
                            if viewModel.isLoading || (viewModel.errorMessage != nil) {
                                ForEach(0...3, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(height: proxy.size.height / 2.75)
                                        .shimmer()
                                        .padding(.horizontal)
                                        .padding(.bottom, -20)
                                }
                                
                            } else {
                                ForEach(Array(filteredArticles.enumerated()), id: \.element.article_id) { index, article in
                                    NewsCardView(
                                        title: article.title,
                                        date: formattedDate(article.pubDate),
                                        imageUrl: article.image_url,
                                        link: article.link,
                                        proxy: proxy
                                    )
                                    .frame(height: proxy.size.height / 3)
                                    
                                    if (index + 1) % adInterval == 0 {
                                        NativeAdView()
                                            .frame(height: 300)
                                            .padding()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100) // para tabbar nao cobrir
                        .background(.clear)
                }.scrollDisabled(viewModel.isLoading || (viewModel.errorMessage != nil))
                
            }.background(.colorBgPrimary)
//                .onAppear {
//                    viewModel.fetcharticles()
//                }
        }
    }
    
    // OBTER CATEGORIAS DOS FILTROS (Traduzindo as categorias)
    func uniqueCategories(from articles: [Article]) -> [String] {
        let allCategories = articles.flatMap { $0.category }
        let uniqueCategories = Array(Set(allCategories)).sorted()
        // remover o "top" - api problemas
        let filteredCategories = uniqueCategories.filter { $0 != "top" }
        print("categorias")
        print(filteredCategories)
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



#Preview {
    NewsView()
        .environmentObject(EssayViewModel())
        .environmentObject(StoreKitManager())
}
