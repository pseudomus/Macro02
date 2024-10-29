//
//  LoginView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack{
            VStack{
                Image("LoginRect")
                    .resizable()
                    .scaledToFit()
//                    .ignoresSafeArea()
                    .frame(height: 700)
                    .padding(.bottom,370)
            }
            // APPLE
            SignInWithAppleButton(.signIn, onRequest: configure, onCompletion: handleAppleLogin)
                .frame(width: 200, height: 50)
                .signInWithAppleButtonStyle(.black)
                .padding()
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - APPLE SIGN IN CONFIGS
    // Configuração antes do pedido de autenticação
    private func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    // APPLE: Manipulação do resultado da autenticação da Apple
    private func handleAppleLogin(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Pegar o token de identidade e enviá-lo para o servidor
                if let identityTokenData = appleIDCredential.identityToken,
                   let identityToken = String(data: identityTokenData, encoding: .utf8) {
                    
                    // Capturar nome (porque a Apple só nos dá a primeira vez)
                    var fullName: String? = nil
                    if let givenName = appleIDCredential.fullName?.givenName,
                       let familyName = appleIDCredential.fullName?.familyName {
                        fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    // MARK: - Enviar o token ao backend
                    userViewModel.login(withProvider: "apple", token: identityToken, name: fullName ?? "User")
                    
                } else {
                    self.errorMessage = "Token de identidade inválido"
                    self.showError = true
                }
                
                let userName = appleIDCredential.fullName?.givenName ?? ""
                let email = appleIDCredential.email ?? ""
                let id = appleIDCredential.user
                print("nome = \(userName)")
                print(email)
                print(id)
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
