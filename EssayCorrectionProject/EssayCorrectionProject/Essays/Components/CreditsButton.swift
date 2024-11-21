//
//  CreditsButton.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 04/11/24.
//

import SwiftUI

struct CreditsButton: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var storeKitManager: StoreKitManager
    var isCompact: Bool = false 

    var body: some View {
        VStack {
            Button {
                navigate(.creditsSheet)
            } label: {
                HStack (spacing: 5) {
                    Image(.creditsStack)
                    if !isCompact { // Mostra o texto apenas se não estiver no estado compacto
                        Text("\(storeKitManager.creditBalance) \(storeKitManager.creditBalance == 1 ? "crédito" : "créditos")")
                            .transition(.opacity) // Adiciona uma transição ao texto
                    } else {
                        Text("\(storeKitManager.creditBalance)") // Exibe apenas o número de créditos
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(Color(.colorBrandPrimary700))
                .clipShape(.capsule)
            }
        }
    }
}



#Preview {
    CreditsButton()
        .environmentObject(StoreKitManager())
}
