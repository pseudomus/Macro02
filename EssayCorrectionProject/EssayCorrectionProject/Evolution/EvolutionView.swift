//
//  EvolutionNavigationStack.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

struct EvolutionNavigationStackView: View {
    
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    @State var baseRouter: [BaseRoute] = []
    @Environment(\.navigate) var navigate
    
    var body: some View {
        NavigationStack(path: $baseRouter) {
            EvolutionView()
                .navigationDestination(for: BaseRoute.self) { node in
                    node.destination
                }
        }
        .environment(\.navigate, NavigateAction(action: { route in
            if case .profile = route {
                baseRouter.append(BaseRoute.profile)
            } else if route == .back && baseRouter.count >= 1 {
                baseRouter.removeLast()
            }
        }))
    }
}

struct EvolutionView: View {
    
    @EnvironmentObject var essayViewModel: EssayViewModel
    @State var correctedEssays: Int = 0
    @State var topMistakes: [(title: String, averageCount: Int)] = []
    @State var size: CGSize = .zero
    
    var body: some View {
        VStack {
            CustomHeaderView(showCredits: false, title: "Evolução", distanceContentFromTop: 50, showSearchBar: false, isScrollable: true, itemsHeight: size.height) { shouldAnimate in
                VStack(alignment: .leading, spacing: 20) {
                    if correctedEssays > 0 {
                        
                        EssayQuantityCardView(correctedEssays: correctedEssays)
                        
                        EvolutionCardView(text: "EIXOS TEMÁTICOS")
                            .padding(.top, 15)
                        
                        EvolutionGraphView(failures: $essayViewModel.failures)
                            .padding(.top, 5)

                        WarningInterventionCardView()
                        
                        VStack(alignment: .leading) {
                            Text("Melhor Redação")
                                .padding(.leading)
                            
                            CorrectedEssayCardView(dayOfCorrection: "20/11/2024")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Para aprimorar")
                                .padding(.leading)
                            
                            CorrectedEssayCardView(dayOfCorrection: "20/11/2024")
                        }
                    } else {
                        VStack {
                            Spacer()
                            Image(.lapisinho2)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                            Text("Corrija sua primeira redação para acompanhar sua evolução")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 50)
                            Spacer()
                        }
                    }
                }.padding(.bottom, 120)
                .getSize { size in
                    self.size = size
                    print(essayViewModel.getNumbersOfEssayErrors())
                }
            }.scrollDisabled(!(correctedEssays > 0))
                .background(.colorBgPrimary)
            
        }
        .onAppear {
            essayViewModel.getNumbersOfEssayErrors()
            correctedEssays = essayViewModel.essays.count
            
            if !essayViewModel.essays.isEmpty {
                topMistakes = essayViewModel.getTopEssayMistakes(in: essayViewModel.essays)
            }
        }
    }
}


struct EvolutionCardView: View {
    
    @State var text: String
    @State var colors: [Color] = [.red, .blue, .purple]
    @State var graphValues: [Int] = [5, 2, 3]
    @State var cardTitles: [String] = ["Argumentação", "Concordância", "Proposta de intervenção"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.subheadline)
                .padding(.bottom, 10)
                .padding(.top, 4)
            
            VStack(alignment: .leading) {
                
                HStack {
                    CircularGraphView(data: CircularGraphData(values: graphValues))
                        .frame(height: 110)
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        ForEach(0..<min(cardTitles.count, colors.count), id: \.self) { index in
                            HStack {
                                Circle()
                                    .frame(width: 8)
                                    .padding(.trailing, 6)
                                    .foregroundStyle(colors[index])
                                Text(cardTitles[index])
                                    .font(.footnote)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            .background(.colorBgSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 17))
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(.white)
            )
           
        } .padding(.horizontal)
    }
}

struct WarningInterventionCardView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 65))
                .fontWeight(.light)
            
            Text("Cuidado com propostas de intervenção genéricas")
                .font(.title3)
                .lineSpacing(10)
                .padding(.leading, 7)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(.white)
        )
        .padding(.horizontal)
    }
}

struct EssayQuantityCardView: View {
    
    var correctedEssays: Int
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(String(format: "%02d", correctedEssays))
                .font(.largeTitle)
            Text("Redações corrigidas")
                .font(.title3)
                .padding(.leading, 15)
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(.white)
        )
        .padding(.horizontal)
    }
}

#Preview {
    EvolutionView()
        .environmentObject(EssayViewModel())
}


