//
//  NewsCardView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

struct NewsCardView: View {
    var title: String
    var date: String
    var imageUrl: String?
    var link: String
    var validLink: URL? { // verifica se é valido o link
        return URL(string: link)
    }
    
    var proxy: GeometryProxy
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Base do Card
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.colorBgSecondary)
                
                // Conteúdo
                VStack(alignment: .leading, spacing: 10) {
                    // Imagem usando AsyncImage
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75) // Largura do card
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6)))
                                .clipped()
                        } placeholder: {
                            // Placeholder enquanto a imagem carrega
                            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                                .foregroundStyle(.gray)
                                .overlay { ProgressView() }
                                .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75) // Largura do card
                        }
                    } else {
                        // Placeholder se não houver URL
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 6, topTrailing: 6))
                            .foregroundStyle(.backgroundBlue)
                            .overlay {
                                Image(.lapisinho) // Ícone padrão como placeholder
                                    .resizable() // Permite redimensionar a imagem
                                    .scaledToFit() // Mantém a proporção da imagem
                                    .foregroundColor(.white.opacity(0.6))
                                
                            }
                            .frame(width: geometry.size.width - 50, height: geometry.size.height * 0.75)
                    }
                    
                    // TEXTOS E PIN
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(title)
                                .fontWeight(.bold)
                            Text(date)
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "pin")
                            .font(.title2)
                            .foregroundStyle(.colorBrandPrimary700)
                    }
                }
                .padding(10)
            }
            .onTapGesture {
                if let validLink = validLink { UIApplication.shared.open(validLink) }
            }
            .padding(.horizontal)
        }
    }
}
