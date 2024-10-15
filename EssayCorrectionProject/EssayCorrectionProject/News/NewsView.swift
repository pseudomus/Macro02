//
//  NewsView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 11/10/24.
//

import SwiftUI

struct sampleData: Hashable {
    let title: String
    let date: String
}

var data: [sampleData] = [
    .init(title: "Título da notícia 1", date: "11/10/24"),
    .init(title: "Título da notícia 2", date: "11/10/24"),
    .init(title: "Título da notícia 3", date: "11/10/24"),
    .init(title: "Título da notícia 4", date: "11/10/24"),
]


struct NewsView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                ForEach(data, id: \.self) { data in
                    NewsCardView(title: data.title, date: data.date)
                        .frame(height:proxy.size.height / 3)
                    
                }
            }
        }
    }
}

struct NewsCardView: View {
    var title: String = "Título da notícia"
    var date: String = "11/10/24"
    
    var body: some View {
        GeometryReader { proxy in
            // CARD
            ZStack(alignment: .top) {
                // Base
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray.opacity(0.5))
                
                // Imagem e textos
                VStack(alignment: .leading, spacing: 10) {
                    // Imagem
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 6,
                        topTrailing: 6))
                    .foregroundStyle(.gray)
                    
                    // TEXTOS E PIN
                    HStack {
                        VStack (alignment: .leading) {
                            Text(title)
                                .fontWeight(.bold)
                            Text(date)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "pin")
                            .font(.title2)
                    }
                    
                }
                .padding(10)
            }
            .padding(.horizontal)

            
        }
    }
}


#Preview {
    NewsCardView()
}

#Preview {
    NewsView()
}
