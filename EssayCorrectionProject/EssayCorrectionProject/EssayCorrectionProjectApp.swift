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
            ContentView()
                .modelContainer(for: [RepertoireFixedFilter.self])
                .environmentObject(userViewModel)
                .environmentObject(essayViewModel)
                .environmentObject(authManager)
                .environmentObject(storeKitManager)
                .onAppear {
                    if userViewModel.user == nil { userViewModel.fetchUserData() }
                    // oculta a overlay após 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
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
    
    @State var isAnimating: Bool = false
    @State var isScaleAnimating: Bool = false
    
    var body: some View {
        VStack (alignment: .center){
            Image(.dissserta)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
                .scaleEffect(isScaleAnimating ? 1.8 : 1)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isScaleAnimating.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        isAnimating.toggle()
                    }
                }
                .blur(radius: isAnimating ? 100 : 0)
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            .opacity(isAnimating ? 0 : 1)
//        .transition(.opacity)
        .animation(.spring(duration: 1.1), value: isAnimating)
        .animation(.spring(duration: 1.1), value: isScaleAnimating)
    }
}
