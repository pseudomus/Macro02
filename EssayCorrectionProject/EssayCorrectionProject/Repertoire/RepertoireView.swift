//
//  RepertoireView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct RepertoireView: View {
    
    @StateObject private var viewModel: RepertoireViewModel = .init()
    @State private var selectedFilters: Set<Theme> = []
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Carregando repertórios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                CustomHeaderView(title: "Repertories", filters: Theme.getArray(), distanceContentFromTop: 45, showSearchBar: false, isScrollable: true, numOfItems: viewModel.repertories.count, onSelectFilter: toggleFilter) { _ in
                    VStack(spacing: 15) {
                        
                        ForEach(filteredRepertoires, id: \.id) { repertoire in
                            RepertoireCardView(author: repertoire.author, descript: repertoire.text, isPinned: .constant(false))
                                .padding(.horizontal)
                        }
                    }.padding(.bottom, 110)
                }
            }
        }.onAppear{
            viewModel.fetchRepertoires()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print(viewModel.repertories)
            }
        }
    }
    
    private func toggleFilter(_ filter: String) {
        guard let filter = Theme(rawValue: filter) else { return }
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter) // Se já está selecionado, remove
        } else {
            selectedFilters.insert(filter) // Se não está selecionado, adiciona
        }
    }
    
    var filteredRepertoires: [Repertoire] {
        if selectedFilters.isEmpty {
            return viewModel.repertories
        } else {
            return viewModel.repertories.filter{ selectedFilters.contains($0.theme) }
        }
    }
}

#Preview {
    RepertoireView()
}

#Preview {
    ContentView()
}
