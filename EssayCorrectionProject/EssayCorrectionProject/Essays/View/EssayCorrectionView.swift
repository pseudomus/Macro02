//
//  EssayCorrectionView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

struct EssayCorrectionView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    private let noAccountText: String = "Preciso que você entre na sua conta da apple para eu poder corrigir e salvar sua redação"
    
    var body: some View {
        if authManager.isAuthenticated {
            // TODO: - FLUXO BRUNO TRANSCRIÇÃO
            Button("Logout") {
                AuthManager.shared.logout()
                essayViewModel.logout()
            } // BOTAO TEMPORARIO DE LOGOUT REMOVER
            EssayInputView()
        } else {
            VStack {
                Text("Essay Correction View")
                
                Spacer()
                
                Text(noAccountText)
                    .font(.footnote)
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                
                AppleLoginView()
                
                Spacer()
            }
        }
    }
}

#Preview {
    EssayCorrectionView()
        .environmentObject(AuthManager.shared)
}
