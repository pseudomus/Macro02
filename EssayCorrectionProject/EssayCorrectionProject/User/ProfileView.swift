//
//  ProfileView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 24/10/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var essayViewModel: EssayViewModel
    @Environment(\.navigate) var navigate
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray5).ignoresSafeArea()
            
            VStack{
                if authManager.isAuthenticated{
                    Circle()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    ProfileTextBox(textToShow: user.user?.name ?? "no name")
                        .padding()
                    
                    ProfileTextBox(textToShow: user.user?.email ?? "no email")
                        .padding()
                    
                    Spacer()
                    
                    LogoutButton(buttonTitle: "Sair da conta", action: {
                        AuthManager.shared.logout()
                        essayViewModel.logout()
                        user.user = nil
                        navigate(.back)
                    })
                    .padding(.bottom,20)
                    .padding(.horizontal, 90)
                } else {
                    AppleLoginView()
                }
            }
            .padding(.top, 50)
            
        }
    }
}

#Preview {
    ProfileView()
}
