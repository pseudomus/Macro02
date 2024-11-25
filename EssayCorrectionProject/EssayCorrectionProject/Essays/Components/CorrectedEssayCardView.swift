//
//  CorrectedEssayCardView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 17/10/24.
//

import SwiftUI

struct CorrectedEssayCardView: View {
    @State var title: String = "Corrected Essay Card"
    @State var description: String = "This is a corrected essay card."
    @State var dayOfCorrection: String
    @State var tags: String = "any"
    @State var isCorrected: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .lineLimit(2)
                    .bold()
                    .foregroundStyle(.black)
                Spacer()
            }
            Text(description)
                .lineLimit(1)
                .foregroundStyle(.black)
            
            HStack {
                Text(dateFormatted)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.7))
                
                Spacer()
                
                TagComponent(label: tags.captalizedSetence)
                
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
        .overlay{
            if !isCorrected {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay {
                        Text("Corrigindo sua redação...")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                    }
            }
        }
        .padding(.horizontal)
    }
    
    
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        
        // Define o formato da data da string original (2024-10-23T21:01:10.547Z)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Converte a string para um objeto Date
        if let date = dateFormatter.date(from: dayOfCorrection) {
            
            // Cria um novo DateFormatter para extrair apenas o dia (dd)
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d" // "d" para pegar apenas o dia (sem leading zero)
            
            // Converte a data para o formato de dia
            let dayString = dayFormatter.string(from: date)
            
            return "Corrigida dia \(dayString)"
        } else {
            print("Erro ao converter a string para Date.")
        }
        
        return "" // Retorna uma string vazia caso a conversão falhe
    }
    
    
}

#Preview {
    CorrectedEssayCardView(dayOfCorrection: "2024-10-23T21:01:10.547Z")
}
