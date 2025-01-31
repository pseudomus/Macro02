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
    @State var isFixedTabOpen: Bool = false
    
    var body: some View {
        VStack{
            
            CustomHeaderView(showCredits: false,
                             title: "Repertório",
                             filters: Theme.getArray(),
                             showFilters: Theme.getArray(),
                             showFiltersBeforeSwipingUp: true,
                             distanceContentFromTop: 100,
                             showSearchBar: false,
                             isScrollable: true,
                             numOfItems: viewModel.repertories.count,
                             onSelectFilter: toggleFilter) { _ in
                VStack(spacing: 15){
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
                    
                    if viewModel.isLoading || filteredRepertoires.isEmpty {
                        ForEach(0...6, id: \.self) { _ in
                            RepertoireCardView(author: "sdjsndjkjds sdsd", descript: "skjdnfjksbd fkbsdjkfb skjdbfkjdsbf kjbsdkjfb dsjkbfjk sdbfkjdbsjkf fkjsdb jkbfsdkj bfsjkdb fkjsbdkj fbsdkj bfskjdb fjkdsb fkjdsbkjfds "){
                                true
                            }
                                .shimmer()
                            .padding(.horizontal, 28)
                        }
                    } else {
                        
                        VStack(spacing: 15) {
                            
                            ForEach(filteredRepertoires, id: \.id) { repertoire in
                                RepertoireCardView(author: repertoire.author, descript: repertoire.text){
                                    viewModel.verifyIfIsPinned(id: "\(repertoire.id)")
                                }
                                .padding(.horizontal, 28)
                            }
                        }.padding(.bottom, 110)
                    }
                }
                
            }.background(.colorBgPrimary)
                .scrollDisabled(viewModel.isLoading || filteredRepertoires.isEmpty)
        }.onAppear{
            viewModel.fetchRepertoires()
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


