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
    @StateObject var storeKitManager = StoreKitManager()
    
    // Estado para controlar a exibição da overlay
    @State private var showOverlay = true

    var body: some Scene {
        WindowGroup {
//            CreditsView()
//                .environmentObject(storeKitManager)
            ContentView()
                .modelContainer(for: [RepertoireFixedFilter.self])
                .environmentObject(userViewModel)
                .environmentObject(essayViewModel)
                .environmentObject(authManager)
                .environmentObject(storeKitManager)
                .onAppear {
                    if userViewModel.user == nil { userViewModel.fetchUserData() }
                    
                    // oculta a overlay após 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showOverlay = false
                    }
                }
                .preferredColorScheme(.light)
                // Overlay condicional com uma imagem
                .overlay(
                    showOverlay ? OverlayView() : nil
                )
                .tint(.colorBrandPrimary700)
        }
    }
}

struct OverlayView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(.dissserta)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            Spacer()
            Text("Disserta")
                .font(.title)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(.gray)
                .padding(.bottom, 70)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
        .transition(.opacity)
        .animation(.easeOut(duration: 0.5), value: UUID())
    }
}
