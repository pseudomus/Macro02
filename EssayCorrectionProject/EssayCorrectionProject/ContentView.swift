//
//  ContentView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: AppScreenNavigation? = .essays
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        AppTabView(selection: $selection)
            .onAppear {
                userViewModel.fetchUserData()
            }
            // overlay temporário
            .overlay(alignment: .top) {
                if userViewModel.isLoading {
                    ProgressView("Carregando usuário...")
                } else {
                    // VIEW EM SI
                    VStack {
                        // Saudações
                        Text("Olá, \(userViewModel.user?.name ?? "") ")
                            .font(.largeTitle)
                        // Logout
                        Button(action: {
                            AuthManager.shared.logout()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                        }
                    }
               }
            }
    }
}

//#Preview {
//    ContentView()
//}
