//
//  EssayCorrectionProjectApp.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI
import SwiftData

@main
struct EssayCorrectionProjectApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var essayViewModel = EssayViewModel()
    @StateObject private var authManager = AuthManager.shared
    
    // Estado para controlar a exibição da overlay
    @State private var showOverlay = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [RepertoireFixedFilter.self])
                .environmentObject(userViewModel)
                .environmentObject(essayViewModel)
                .environmentObject(authManager)
                .onAppear {
                    if userViewModel.user == nil {
                        userViewModel.fetchUserData()
                        
                        // Verificar se o usuário ainda é nil depois de 1 segundo
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if userViewModel.user == nil {
                                essayViewModel.fetchEssays(userId: "105")
                            }
                        }
                    }
                    
                    // Oculta a overlay após 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showOverlay = false
                    }
                }
                .preferredColorScheme(.light)
                // Overlay condicional com uma imagem
                .overlay(
                    showOverlay ? OverlayView() : nil
                )
        }
    }
}

struct OverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
        }
        .transition(.opacity)
        .animation(.easeOut(duration: 0.5), value: UUID())
    }
}
