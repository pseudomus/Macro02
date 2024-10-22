//
//  RepertoireView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

enum RepertoireFilter: String, CaseIterable {
    case rights = "Direitos e Cidadania"
    case economy = "Economia"
    case tecnology = "Tecnologia"
    case education = "Educação"
    case culture = "Arte e Cultura"
    case politics = "Política"
    case nature = "Meio Ambiente"
    case health = "Saúde e Ciência"
    
    static func getArray() -> [String] {
        let filter = RepertoireFilter.allCases
        return filter.map(\.rawValue)
    }
    
    func verifyIfStringAPIRequestIsPartOfFilter(_ string: String) -> Bool {
        return rawValue.contains(string)
    }
}

struct RepertoireView: View {
    
    @StateObject private var viewModel: RepertoireViewModel = .init()
    @State private var selectedFilters: Set<RepertoireFilter> = []
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Carregando repertórios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                CustomHeaderView(title: "Repertories", filters: RepertoireFilter.getArray(), distanceContentFromTop: 45, showSearchBar: false, isScrollable: true, numOfItems: viewModel.repertories.count) { _ in
                    VStack(spacing: 15) {
                        
                        ForEach(filteredRepertoires, id: \.id) { repertoire in
                            RepertoireCardView(author: repertoire.author, descript: repertoire.description, isPinned: .constant(false))
                                .padding(.horizontal)
                            
                        }
                        
                    }.padding(.bottom, 110)
                    
                }
            }
        }.onAppear{
            viewModel.fetchRepertoires()
        }
    }
    
    var filteredRepertoires: [Citation] {
        return viewModel.repertories
    }
}

#Preview {
    RepertoireView()
}

#Preview {
    ContentView()
}
