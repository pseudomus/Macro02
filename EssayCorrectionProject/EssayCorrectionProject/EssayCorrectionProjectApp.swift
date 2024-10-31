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
                        
                        // verificar se é nil ainda dps de 1s
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if userViewModel.user == nil { essayViewModel.fetchEssays(userId: "105") }
                        }
                    }
                }
                .preferredColorScheme(.light)
        }
    }
}
