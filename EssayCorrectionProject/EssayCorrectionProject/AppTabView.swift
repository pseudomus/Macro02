//
//  AppTabView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreenNavigation?

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreenNavigation.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreenNavigation?)
                    .tabItem {
                        screen.label
                    }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var userViewModel = UserViewModel()
    @Previewable @StateObject var essayViewModel = EssayViewModel()
    @Previewable @StateObject var authManager = AuthManager.shared
    @Previewable @StateObject var storeKitManager = StoreKitManager()
    
    return ContentView()
        .environmentObject(userViewModel)
        .environmentObject(essayViewModel)
        .environmentObject(authManager)
        .environmentObject(storeKitManager)
        .onAppear { if userViewModel.user == nil { userViewModel.fetchUserData() } } // Fetch user data when opening again without login
        .modelContainer(for: [RepertoireFixedFilter.self])
}
