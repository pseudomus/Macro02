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
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(authManager)
                .onAppear { if userViewModel.user == nil { userViewModel.fetchUserData() } } // Fetch user data when opening again without login
        }
    }
}
