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
            
            CustomHeaderView(showCredits: false,
                             title: "Repertories",
                             filters: Theme.getArray(),
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


extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}

struct ShimmerEffect: ViewModifier {
    
    private var min = -0.5
    private var max = 1.5
    @State private var isAnimating: Bool = true
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack{
                    Color.white
                    Color.gray.opacity(isAnimating ? 0.4 : 0.5)
                        .animation(.easeIn(duration: 0.7).delay(0.35).repeatForever(autoreverses: true), value: isAnimating)
                    LinearGradient(
                        colors: [.gray.opacity(0.1), .gray.opacity(0.3),
                                 
                            .gray.opacity(0.4),.gray.opacity(0.3), .gray.opacity(0.1)],
                        startPoint: isAnimating ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1),
                        endPoint: isAnimating ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
                    )
                    .scaleEffect(1.7)
//                    .rotationEffect()
                    
                    .animation(.easeIn(duration: 1.4).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = false
                    }
//                    Color.white
                }.mask(content)
                
            }
    }
}
