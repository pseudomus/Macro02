//
//  RepertoireView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct RepertoireNavigationStackView: View {
    
    @State var baseRouter: [BaseRoute] = []
    @Environment(\.navigate) var navigate
    
    var body: some View {
        NavigationStack (path: $baseRouter){
            RepertoireView()
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

struct RepertoireView: View {
    
    @StateObject private var viewModel: RepertoireViewModel = .init()
    @State private var selectedFilters: Set<Theme> = []
    @State var isFixedTabOpen: Bool = false
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Carregando repertórios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                CustomHeaderView(showCredits: false, title: "Repertories", filters: Theme.getArray(), distanceContentFromTop: 45, showSearchBar: false, isScrollable: true, numOfItems: viewModel.repertories.count, onSelectFilter: toggleFilter) { _ in
                    VStack(spacing: 15) {
                        
                        Button{
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
                        
                        ForEach(filteredRepertoires, id: \.id) { repertoire in
                            RepertoireCardView(author: repertoire.author, descript: repertoire.text){
                                viewModel.verifyIfIsPinned(id: "\(repertoire.id)")
                            }
                                .padding(.horizontal)
                        }
                    }.padding(.bottom, 110)
                }
            }
        }.onAppear{
            viewModel.fetchRepertoires()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                print(viewModel.repertories)
//            }
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
