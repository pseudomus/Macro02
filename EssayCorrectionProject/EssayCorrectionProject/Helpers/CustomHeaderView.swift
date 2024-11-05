//
//  CustomHeaderView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 14/10/24.
//

import SwiftUI



// MARK: - CustomHeaderView
struct CustomHeaderView<Content: View>: View {

    // MARK: - Properties
    var showCredits: Bool
    var title: String                                       // TÍTULO
    var filters: [String]?                                  // FILTROS (opcional)
    var showFiltersBeforeSwipingUp: Bool?                   // MOSTRAR FILTROS ANTES DE SCROLLAR (opcional) - para notícias
    var distanceContentFromTop: CGFloat                     // DISTANCIA QUE COMECA O CONTEÚDO DO TOPO
    var showSearchBar: Bool                                 // MOSTRAR A SEARCHBAR
    var isScrollable: Bool                                  // É CONTEÚDO COM SCROLL
    var numOfItems: Int?                                    // NUMERO DE ITENS (opcional) *para a tela redações*
    var itemsHeight: CGFloat?                               // ALTURA DOS ITENS PARA ANIMACAO (opcional) *para a tela redações*
    var onSearch: ((String) -> Void)?                       // CLOSURE - pesquisa da searchbar (opcional)
    var onCancelSearch: (() -> Void)?                       // CLOSURE - cancelamento da pesquisa (opcional)
    var onSelectFilter: ((String) -> Void)?                 // CLOSURE - ao clicar em filtro (opcional)
    var content: (Bool) -> Content                          // CONTEÚDO INSERIDO (A VIEW EM SI)

    @State private var searchQuery: String = ""
    @FocusState private var searchFieldIsFocused: Bool 
    @State private var selectedFilters: Set<String> = []   // Estado para armazenar filtros selecionados

    // Animations
    @State private var opacity: Double = 0
    @State private var scrollOffset: CGFloat = 0
    private var shouldAnimate: Bool {
        opacity > 0.6
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {

                // BG COLOR
                Color(uiColor: .systemGray5).ignoresSafeArea()

                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            headerBackground(in: geometry)
                            contentView(geometry: geometry)
                        }
                    }
                    .onChange(of: searchFieldIsFocused) { _, newValue in
                        let target = newValue ? "scrollTop" : "scrollBottom"
                        withAnimation { scrollProxy.scrollTo(target, anchor: .top) }
                    }
//                    .onChange(of: shouldAnimate) { _, newValue in
//                        if newValue {
//                            withAnimation { scrollProxy.scrollTo("scrollTop", anchor: .top) }
//                        }
//                    }
                    .scrollDisabled(!isScrollable)

                }
                // Distância entre filtro e o título
                VStack(spacing: 0) {
                    headerTitleView(in: geometry)

                    if let filters = filters {
                        filtersView(filters: filters)
                    }
                }
                

            }
            .animation(.bouncy(duration: 0.2), value: opacity)
        }
        .ignoresSafeArea()
        .background(.gray.opacity(0.05))
        .overlay(alignment: .topTrailing){
            if !shouldAnimate {
                HStack {
                    if showCredits { CreditsButton() }
                    ProfileButton()
                }
                .ignoresSafeArea()
                .padding(10)
            }
        }
        
    }

    // MARK: - Header Background
    @ViewBuilder
    private func headerBackground(in geometry: GeometryProxy) -> some View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY
            let height = geometry.size.height / 5

            UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20)) // IMAGEM DO HEADER
                .foregroundStyle(.gray)
                .frame(height: minY > 0 ? minY + height : height * (1 - opacity))
                .offset(y: -minY)
                .id("scrollBottom")
                .onChange(of: minY) { _, value in
                    updateOpacity(for: value, height: height)
                }
        }
        .frame(height: geometry.size.height / 5)
    }

    // MARK: - Content View
    @ViewBuilder
    private func contentView(geometry: GeometryProxy) -> some View {
        VStack {
            content(shouldAnimate).id("scrollTop")
            // Placeholder invisível para ajustar a rolagem
            Spacer()
                .frame(height: max(geometry.size.height - totalContentHeight(), 0))
        }
        .padding(.top, distanceContentFromTop) // Distância do conteúdo do topo
    }

    // MARK: - Header Title View
    @ViewBuilder
    private func headerTitleView(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            ZStack(alignment: shouldAnimate ? .center : .leading) {
                if !shouldAnimate {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 80)
                        .foregroundStyle(.ultraThinMaterial)
                }

                Text(title)
                    .font(shouldAnimate ? .callout : .largeTitle)
                    .foregroundStyle(.black)
                    .padding(.leading, shouldAnimate ? 0 : .none)
            }
            if showSearchBar {
                searchBar()
            }
        }
        .padding(.horizontal)
        .foregroundStyle(shouldAnimate ? .black : .white)
        .padding(.top, shouldAnimate ? geometry.safeAreaInsets.top + geometry.size.height * 0.08 : geometry.size.height * 0.14) // Distância do título do topo
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(opacity))
    }

    // MARK: - Helper Methods
    private func totalContentHeight() -> CGFloat {
        let numberOfItems = numOfItems ?? 0
        if let itemsHeight = itemsHeight {
            return (itemsHeight + 180) + distanceContentFromTop
        } else {
            let numberOfItems = numOfItems ?? 0
            let itemHeight: CGFloat = 140 + 50
            return CGFloat( numberOfItems) * itemHeight + distanceContentFromTop
        }
    }

    // MARK: - Search Bar
    @ViewBuilder
    private func searchBar() -> some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchQuery)
                    .focused($searchFieldIsFocused)
                    .onChange(of: searchQuery) { _, newValue in
                        onSearch?(newValue)
                    }
                    .onChange(of: searchFieldIsFocused) { _, isFocused in
                        searchFieldIsFocused = isFocused
                    }

                if !searchQuery.isEmpty {
                    Button(action: clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(uiColor: .systemGray4))
            .foregroundStyle(.gray)
            .clipShape(.buttonBorder)

            if searchFieldIsFocused {
                Button("Cancel", action: cancelSearch)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .trailing))
            }
        }
        
        .animation(.default, value: searchFieldIsFocused)
    }


    // MARK: - Filters View
    @ViewBuilder
    private func filtersView(filters: [String]) -> some View {
        let showFilters = showFiltersBeforeSwipingUp == true // Verifica se é `true`, trata `nil` como `false`

        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.clear]),
                       startPoint: .top,
                       endPoint: .bottom)
        .opacity(showFilters ? (shouldAnimate ? 1 : 0) : 1)
        .frame(height: showFilters ? (shouldAnimate ? 50 : 25) : 50)
        .overlay {
            filterScrollView(for: filters)
        }
        .opacity(showFilters ? 1 : opacity)
    }

   // MARK: - Filter Button
   @ViewBuilder
   private func filterButton(for filter: String) -> some View {
       let isSelected = selectedFilters.contains(filter) // Verifica se o filtro está selecionado
       
       Text(filter)
           .font(.footnote)
           .padding(8)
           .background(isSelected ? Color.white : Color(uiColor: .systemGray4)) // Cor do fundo baseada na seleção
           .clipShape(Capsule())
           .overlay(
               Capsule()
                   .stroke(Color.white, lineWidth: 3)
           )
           // Click no filtro
           .onTapGesture {
               toggleFilter(filter) // Alternar seleção de filtros
               onSelectFilter?(filter) // Chamar a closure opcional
           }
   }

   // MARK: - Helper Methods
   private func toggleFilter(_ filter: String) {
       if selectedFilters.contains(filter) {
           selectedFilters.remove(filter) // Remove se já está selecionado
       } else {
           selectedFilters.insert(filter) // Adiciona se não está selecionado
       }
   }

    // MARK: - Helper Methods
    private func updateOpacity(for offset: CGFloat, height: CGFloat) {
        if offset < -20 {
            opacity = offset > 0 ? Double((30 - offset) / 30) : 1
        } else {
            opacity = 0
        }
        scrollOffset = offset
    }

    private func clearSearch() {
        searchQuery = ""
        searchFieldIsFocused = false
    }

    private func cancelSearch() {
        searchQuery = ""
        searchFieldIsFocused = false
        onCancelSearch?()  // Só chama se existir
    }
    
    // Função auxiliar para criar o ScrollView de filtros
    private func filterScrollView(for filters: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters, id: \.self) { filter in
                    filterButton(for: filter) // Passando o filtro para o botão
                }
            }
            .padding(.leading)
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    CustomHeaderView(showCredits: false, title: "Redações",
                     filters: ["Filtro 1", "Filtro 2"],
                     showFiltersBeforeSwipingUp: true,
                     distanceContentFromTop: 90,
                     showSearchBar: false,
                     isScrollable: true) { _ in
        // CONTEÚDO DA VIEW AQUI
        VStack {
            ForEach(0..<20) { _ in
                Text("Conteúdo aqui")
            }
        }
    }
}
