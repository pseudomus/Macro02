//
//  BuyCreditsButton.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


import SwiftUI
import StoreKit

struct BuyCreditsButton: View {
    var product: Product
    var iconSize: CGFloat = 40

    // Extrai apenas o número do nome do produto
    private var creditAmount: String {
        let components = product.displayName.split(separator: " ") // Divide por espaço
        return components.first.map { String($0) } ?? product.displayName // Retorna o primeiro componente ou o nome completo
    }

    // Formata o preço para o formato "R$ 2,90" e deixa o número inteiro (2) em negrito
    private var formattedPrice: (String, String) {
        // Converte o preço de Decimal para Double
        let priceAsDouble = NSDecimalNumber(decimal: product.price).doubleValue
        
        // Converte o preço para string com 2 casas decimais
        let priceString = String(format: "%.2f", priceAsDouble)
        
        // Divide a string no ponto (.) para separar reais e centavos
        let components = priceString.split(separator: ".")
        let reais = String(components[0])    // Parte inteira (ex: 2)
        let centavos = String(components[1]) // Parte decimal (ex: 90)
        
        return (reais, centavos)
    }
    
    // Seleciona o ícone com base no número de créditos
    private var selectedIcon: Image {
        switch creditAmount {
        case "1": return Image("coin1")
        case "4": return Image("coin2")
        default: return Image("coin3")
        }
    }

    var body: some View {
        VStack {
            // Quantidade + Ícone
            HStack(spacing: 5) {
                Text(creditAmount)
                selectedIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize)
                    .padding(.top, 15)
            }
            .font(.system(size: 44))
            .fontWeight(.bold)
            
            Spacer()
            
            // PREÇO
            HStack(alignment: .bottom, spacing: 0) {
                Text("R$ ")
                Text(formattedPrice.0) // Parte antes da vírgula (número inteiro)
                    .bold()
                    //.padding(.bottom, 2)
                Text(",\(formattedPrice.1)")   // Parte depois da vírgula
            }
            .font(.largeTitle)
        }
        .padding(20)
        .padding(.vertical, 20)
        .background(Color.colorBrandPrimary500)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.colorBrandPrimary700, radius: 0, y: 8)
        .frame(height: 200)
        .onAppear { print(product.price) }
    }
}



//#Preview {
//    BuyCreditsButton(numberOfCredits: 1, price: 2.90)
//}
