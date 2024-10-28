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
    @State var tags: [String] = ["tag", "tag"]
    @State var isCorrected: Bool = true
    @Environment(\.navigate) var navigate
    
    var body: some View {
        Button{

        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .lineLimit(1)
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
                        .foregroundStyle(.black)

                    Spacer()
                    ForEach(tags.indices, id: \.self) { index in
                        if index < 2 {
                            Text(tags[index])
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray)
                                .clipShape(.rect(cornerRadius: 7))
                                .foregroundStyle(.black)

                        }
                    }
                }
            }.padding(.horizontal, 12)
                .padding(.vertical, 10)
            .background(Color.gray.opacity(0.6))
            .clipShape(.rect(cornerRadius: 10))
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
            .padding(.vertical, 10)
        }
        
    }
    
    var dateFormatted: String {
        let dateFormatter = DateFormatter()

        // Set Date Format (2024-10-23T21:01:10.547Z)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // Convert String to Date
        dateFormatter.date(from: dayOfCorrection)
        
        if let date = dateFormatter.date(from: dayOfCorrection) {
            print("Data convertida: \(date)")
            
            let reducedFormatter = DateFormatter()
                reducedFormatter.dateFormat = "dd/MM/yyyy"
                
                let reducedDateString = reducedFormatter.string(from: date)
            
            return reducedDateString
        } else {
            print("Erro ao converter a string para Date.")
        }
        
        return ""
    }
}

