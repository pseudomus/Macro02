//
//  EssayCorrectionProjectApp.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

@main
struct EssayCorrectionProjectApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var authManager = AuthManager.shared

    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if authManager.isAuthenticated {
                    ContentView(userViewModel: userViewModel)
                        .transition(.move(edge: .trailing))
                } else {
                    AppleLoginView(userViewModel: userViewModel)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: AuthManager.shared.isAuthenticated)
        }
    }
}
