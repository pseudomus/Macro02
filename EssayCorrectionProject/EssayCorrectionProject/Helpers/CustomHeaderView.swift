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
    var title: String                                       // TÍTULO
    var filters: [String]?                                  // FILTROS (opcional)
    var distanceContentFromTop: CGFloat                     // DISTANCIA QUE COMECA O CONTEÚDO DO TOPO
    var showSearchBar: Bool                                 // MOSTRAR A SEARCHBAR
    var isScrollable: Bool                                  // É CONTEÚDO COM SCROLL
    var numOfItems: Int?                                    // NUMERO DE ITENS (opcional) *para a tela redações*
    var onSearch: ((String) -> Void)?                       // CLOSURE - pesquisa da searchbar (opcional)
    var onCancelSearch: (() -> Void)?                       // CLOSURE - cancelamento da pesquisa (opcional)
    var content: (Bool) -> Content                          // CONTEÚDO INSERIDO (A VIEW EM SI)

    @State private var searchQuery: String = ""
    @FocusState private var searchFieldIsFocused: Bool 

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
        
    }

    // MARK: - Header Background
    @ViewBuilder
    private func headerBackground(in geometry: GeometryProxy) -> some View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY
            let height = geometry.size.height / 5

            RoundedRectangle(cornerRadius: 20) // IMAGEM DO HEADER
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
        .padding(.top, shouldAnimate ? geometry.safeAreaInsets.top + 70 : 120) // Distância do título do topo
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(opacity))
    }

    // MARK: - Helper Methods
    private func totalContentHeight() -> CGFloat {
        let numberOfItems = numOfItems ?? 0
        let itemHeight: CGFloat = 140 + 50
        return CGFloat(numberOfItems) * itemHeight + distanceContentFromTop
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
                    .foregroundColor(.blue)
                    .transition(.move(edge: .trailing))
            }
        }
        
        .animation(.default, value: searchFieldIsFocused)
    }


    // MARK: - Filters View
    @ViewBuilder
    private func filtersView(filters: [String]) -> some View {
        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.clear]),
                       startPoint: .top,
                       endPoint: .bottom)
        .frame(height: 50)
        .overlay {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filters, id: \.self) { filter in
                        filterButton(for: filter)
                    }
                }
                .padding(.leading)
                .padding(.vertical, 2)
            }
        }
        .opacity(opacity)
    }

    // MARK: - Filter Button
    @ViewBuilder
    private func filterButton(for filter: String) -> some View {
        Text(filter)
            .font(.footnote)
            .padding(8)
            .background(Color(uiColor: .systemGray4))
            .clipShape(.capsule)
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 2)
            )
            .onTapGesture {
                // TODO: - FILTROS
                print("Selecionar filtro: \(filter)")
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
}

#Preview {
    CustomHeaderView(title: "Redações",
                     filters: ["Filtro 1", "Filtro 2"],
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
