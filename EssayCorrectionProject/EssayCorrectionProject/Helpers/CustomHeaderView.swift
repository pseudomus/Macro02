//
//  CustomHeaderView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 14/10/24.
//

import SwiftUI



// MARK: - CustomHeaderView
struct CustomHeaderView<Content: View>: View {
    @EnvironmentObject var essayViewModel: EssayViewModel

    // MARK: - Properties
    var showCredits: Bool
    var title: String                                       // TÍTULO
    @State var filters: [String]?                           // FILTROS (opcional)
    var showFilters: [String]?                               // ORDEM DOS FILTROS
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
    
    @State private var isUserScrollDisabled = false // para controlar o scroll quando há a animação
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
                Color(uiColor: .clear).ignoresSafeArea()

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
                    .onChange(of: essayViewModel.shouldFetchEssays) { _, newValue in
                        if essayViewModel.essays.isEmpty, newValue {
                            withAnimation {
                                scrollProxy.scrollTo("scrollBottom", anchor: .top)
                                essayViewModel.isFirstTime = true
                            }
                        }
                    }
                    // CONTROLAR SCROLL AUTOMÁTICO, BLOQUEANDO O SCROLL MANUAL DO USUÁRIO
//                    .onChange(of: shouldAnimate) { oldValue, newValue in
//                        if newValue {
//                            isUserScrollDisabled = true
//                            withAnimation {
//                                scrollProxy.scrollTo("scrollTop", anchor: .top)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                    isUserScrollDisabled = false
//                                }
//                            }
//                        } else {
//                            isUserScrollDisabled = true
//                            withAnimation {
//                                scrollProxy.scrollTo("scrollBottom", anchor: .top)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                    isUserScrollDisabled = false
//                                }
//                            }
//                        }
//                    }
                    .scrollDisabled(!isScrollable || isUserScrollDisabled)

                }
                // Distância entre filtro e o título
                VStack(spacing: 0) {
                    headerTitleView(in: geometry)

                    if let filters = filters {
                        filtersView(filters: filters)
                    }
                }
                .offset(y: !shouldAnimate ? scrollOffset : 0)
                

            }
            .animation(.bouncy(duration: 0.2), value: opacity)
        }
        .ignoresSafeArea()
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

    // MARK: - HEADER GRANDE
    @ViewBuilder
    private func headerBackground(in geometry: GeometryProxy) -> some View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY
            let height = geometry.size.height / 5
            let scale = max(1.0, 1 + minY / height)

            ZStack {
                // IMAGEM DO HEADER
                Image(.headerBGimage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .frame(height: minY > 0 ? minY + height : height * (1 - opacity))
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20)))
                    .offset(y: -minY)
                
                // COR DE FUNDO SOBRE A IMAGEM
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
                    .foregroundStyle(Color(.colorFillsPrimary).opacity(0.5)) // Ajuste a opacidade para o efeito desejado
                    .frame(height: minY > 0 ? minY + height : height * (1 - opacity))
                    .offset(y: -minY)
                    .id("scrollBottom")
                    .onChange(of: minY) { _, value in
                        updateOpacity(for: value, height: height)
                    }
            }
        }
        .frame(height: geometry.size.height / 5)
    }

    
    // MARK: - HEADER PEQUENO
    @ViewBuilder
    private func headerTitleView(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            ZStack(alignment: shouldAnimate ? .center : .leading) {
                if !shouldAnimate {
                    // Retangulo que comporta titulo
                    BlurView(style: .systemUltraThinMaterial)
                        .frame(height: 80)
                        .clipShape(.rect(cornerRadius: 15))
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
                }
                // titulo
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
        .background(
            ZStack {
                if shouldAnimate {
                    BlurView(style: .systemUltraThinMaterial)
                    Color.colorFillsPrimary
                }
            }
        )
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
                TextField("Pesquisar", text: $searchQuery)
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
           .background(isSelected ? .colorBrandSecondary300 : .colorMiscellaneousFilterDefault) // Cor do fundo baseada na seleção
           .clipShape(Capsule())
           .overlay(
               Capsule()
                .stroke(.colorBrandSecondary300, lineWidth: 1)
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
           withAnimation {
               selectedFilters.remove(filter)// Remove se já está selecionado
               if let index = showFilters?.firstIndex(of: filter) {
                   if selectedFilters.count < index {
                       filters?.move(filter, to: index)
                   } else {
                       filters?.sort(by: { (lhs, rhs) -> Bool in
                           selectedFilters.contains(lhs)
                       })
                   }
               }
           }
       } else {
           withAnimation {
               filters?.move(filter, to: 0)
               selectedFilters.insert(filter) // Adiciona se não está selecionado
           }
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
                     distanceContentFromTop: 120,
                     showSearchBar: true,
                     isScrollable: true) { _ in
        // CONTEÚDO DA VIEW AQUI
        VStack {
            ForEach(0..<20) { _ in
                Text("Conteúdo aqui")
            }
        }
    }
     .environmentObject(EssayViewModel())
}
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
