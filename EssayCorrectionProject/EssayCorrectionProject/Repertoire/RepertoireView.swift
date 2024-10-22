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

struct RepertoireCardView: View {
    
    @State var title: String
    @State var descript: String
    @Binding var isPinned: Bool
    private let pasterboard = UIPasteboard.general
    
    var body: some View {
        VStack{
            HStack{
                Text("Repertoire Card")
                    .bold()
                Spacer()
                Button{
                    isPinned.toggle()
                } label: {
                    if isPinned{
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.black)
                    } else {
                        Image(systemName: "pin")                        .foregroundStyle(.black)
                    }
                    
                }
                Button{
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Button{
                    
                } label: {
                    Image(systemName: "document.on.document")
                }
            }
            
            HStack {
                Text(descript)
                Spacer()
            }
                
        }.padding()
        .background{
            Color.white
        }
        .clipShape(.rect(cornerRadius: 10))
        .padding()
    }
}

class RepertoireViewModel: ObservableObject {
    @Published var repertories: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let repertoireService: RepertoireService
    
    init(container: DependencyContainer = .shared) {
        self.repertoireService = container.repertoireService
    }
    
    func fetchRepertoires() {
        isLoading = true
        repertoireService.fetchRepertoires { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let repertories):
                    self?.repertories = repertories
                case .failure(let error):
                    self?.errorMessage = "Erro ao carregar artigos: \(error.localizedDescription)"
                }
            }
        }
    }
    
}

struct RepertoireView: View {
    
    @StateObject private var viewModel: RepertoireViewModel = .init()
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Carregando repertórios...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                CustomHeaderView(title: "Repertories", filters: RepertoireFilter.getArray(), distanceContentFromTop: 25, showSearchBar: false, isScrollable: true) { _ in
                    VStack {
                        
                        /*ForEach(filteredRepertoires, id: \.article_id) { repertoire in*/
                        RepertoireCardView(title: "Teste de Título", descript: "Teste de description", isPinned: .constant(true))
//                        }
                        
                    }
                    
                }
            }
        }.onAppear{
            viewModel.fetchRepertoires()
        }
    }
    
    var filteredRepertoires: [Article] {
        return viewModel.repertories
    }
}

#Preview {
    RepertoireView()
}

#Preview {
    ContentView()
}
