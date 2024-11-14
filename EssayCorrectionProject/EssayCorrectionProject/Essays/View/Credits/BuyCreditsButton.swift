//
//  BuyCreditsButton.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


import SwiftUI

struct BuyCreditsButton: View {
    var numberOfCredits: Int
    var price: Double
    var iconSize: CGFloat = 40
    
    // Formata o preço manualmente para "2,90"
    private var formattedPrice: (String, String) {
        let priceString = String(format: "%.2f", price)
        let components = priceString.split(separator: ".")
        let reais = String(components[0])    // Parte antes da vírgula
        let centavos = String(components[1]) // Parte depois da vírgula
        return (reais, centavos)
    }
    
    // Determina o ícone com base no número de créditos
    private var selectedIcon: Image {
        switch numberOfCredits {
        case 1: return Image("coin1")
        case 4: return Image("coin2")
        default: return Image("coin3")
        }
    }
    
    var body: some View {
        VStack {
            // QUANTIDADE + ICONE
            HStack {
                Text(String(numberOfCredits))
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
                    .padding(.bottom, 2)
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
    }
}





#Preview {
    BuyCreditsButton(numberOfCredits: 1, price: 2.90)
}
