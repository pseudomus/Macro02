//
//  EvolutionNavigationStack.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

struct EvolutionView: View {
    
    @State var correctedEssays: Int = 1
    
    var body: some View {
        VStack{
            if correctedEssays > 0 {
                CustomHeaderView(title: "Evolução", distanceContentFromTop: 50, showSearchBar: false, isScrollable: true) { shouldAnimate in
                    VStack(alignment: .leading,spacing: 20){
                        
                        EssayQuantityCardView(correctedEssays: $correctedEssays)
                        
                        EvolutionCardView(text: "Pontos fortes")
                        EvolutionCardView(text: "Pontos fracos")
                        
                        WarningInterventionCardView()
                        
                        Text("Média de Métricas")
                            .padding(.leading)
                    }
                }
                
            } else {
                VStack{
                    ContentUnavailableView("Parece que você não corrigiu nenhuma redação ainda.", systemImage: "pencil.and.outline")
                }
            }
        }
    }
}

struct EvolutionCardView: View {
    
    @State var text: String
    @State var colors: [Color] = [.red, .blue, .purple]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.title3)
                .padding(.bottom, 10)
                .padding(.top, 4)
            HStack {
                CircularGraphView(data: CircularGraphData.init(values: [1,2,3]))
                    .frame(height: 110)
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(0..<3, id: \.self) { i in
                        HStack {
                            Circle()
                                .frame(width: 8)
                                .padding(.trailing, 6)
                                .foregroundStyle(colors[i])
                            Text("Proposta de intervenção")
                                .font(.footnote)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.mix(with: .white, by: 0.5))
        .clipShape(.rect(cornerRadius: 17))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 17)
                .stroke(style: .init(lineWidth: 1))
                .foregroundStyle(.white)
        })
        .padding(.horizontal)
        
    }
    
}

#Preview {
    EvolutionView()
}

struct WarningInterventionCardView: View {
    var body: some View {
        HStack(alignment: .center){
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
        .background(Color.gray.mix(with: .white, by: 0.5))
        .clipShape(.rect(cornerRadius: 15))
        .overlay{
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: .init(lineWidth: 1))
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}

struct EssayQuantityCardView: View {
    
    @Binding var correctedEssays: Int
    
    var body: some View {
        HStack(alignment: .bottom){
            Text(String(format: "%02d", correctedEssays))
                .font(.largeTitle)
            Text("Redações corrigidas")
                .font(.title3)
                .padding(.leading, 15)
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.gray.mix(with: .white, by: 0.5))
        .clipShape(.rect(cornerRadius: 15))
        .overlay{
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: .init(lineWidth: 1))
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}
