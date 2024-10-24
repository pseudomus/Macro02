//
//  ProfileView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 24/10/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @State var user: User
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray5).ignoresSafeArea()
            
            VStack{
                Circle()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                
                ProfileTextBox(textToShow: user.name)
                    .padding()
                
                ProfileTextBox(textToShow: user.email)
                    .padding()
                
                
                Spacer()
                
                
                LogoutButton(buttonTitle: "Sair da conta", action: AuthManager.shared.logout)
                    .padding(.bottom,20)
                    .padding(.horizontal, 90)
            }
            .padding(.top, 50)
            
            
        }
    }
}

#Preview {
    ProfileView(user: User(id: 10, name: "teste", email: "teste@gmail.com"))
}
