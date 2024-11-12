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
    @State var isTabBarHidden: Bool = true
    
    var body: some View {
        ZStack {
            Color(uiColor: .colorBgPrimary).ignoresSafeArea()
            
            VStack{
                if authManager.isAuthenticated{
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    isTabBarHidden = false
                                }
                                navigate(.popBackToRoot)
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .fontWeight(.light)
                                    .frame(width: 28)
                                    .foregroundStyle(.colorBrandPrimary700)
                                    .padding(.top)
                                    .padding(.bottom)
                                    .padding(.trailing)
                                    .padding(.trailing, 5)
                                //                        .padding(.top, 8)
                            }
                        }.overlay {
                            HStack(alignment: .center) {
                                Text("User")
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    
                    List {
                        Section{
                            Text(user.user?.name ?? "no name")
                            Text(user.user?.email ?? "no email")
                        }
                        Section{
                            NavigationLink{
                                PrivacyPolicy()
                            } label: {
                                Text("Política de privacidade")
                            }
                     
                        }
                    }.background(.colorBgPrimary)
                        .tint(.colorBrandPrimary700)
                    
                    Spacer()
                    
                    LogoutButton(buttonTitle: "Finalizar Sessão", action: {
                        AuthManager.shared.logout()
                        essayViewModel.logout()
                        user.user = nil
                        navigate(.back)
                    })
                    .padding(.bottom,20)
                    .padding(.horizontal, 90)
                } else {
                    AppleLoginView()
                        .padding(.top, 50)
                }
            }
            
        }.toolbar(isTabBarHidden ? .hidden : .visible, for: .tabBar)
            .navigationBarBackButtonHidden()
            .onAppear{
                withAnimation {
                    isTabBarHidden = true
                }
            }
    }
}

struct PrivacyPolicy: View {
    
    @State var text: [(String, String)] = [
        ("1. Introdução","Bem-vindo ao nosso aplicativo. Nos comprometemos a proteger a privacidade e a segurança dos dados pessoais de nossos usuários. Esta Política de Privacidade descreve como coletamos, usamos e protegemos suas informações. Ao utilizar nosso aplicativo, você concorda com os termos desta política."),
        ("2. Dados Coletados","Ao utilizar o aplicativo, coletamos e armazenamos as seguintes informações pessoais:\n - Nome: utilizado para personalizar a experiência do usuário.\n- E-mail: utilizado para comunicação e autenticação do usuário.\n- Redações Enviadas: armazenamos as redações enviadas pelo usuário, incluindo correções e sugestões de melhorias associadas."),
        ("3. Como Usamos Seus Dados","Os dados coletados são utilizados para fornecer e melhorar nossos serviços, conforme descrito abaixo:\n- Nome e E-mail: para autenticação, comunicação e personalização de experiência dentro do aplicativo.\n- Redações e Correções: armazenamos as redações enviadas e suas respectivas correções para que o usuário possa acompanhar seu progresso ao longo do tempo, revisar os feedbacks recebidos e aprimorar suas habilidades."),
        ("5. Armazenamento e Segurança dos Dados","Adotamos medidas técnicas e organizacionais para proteger seus dados pessoais contra acesso, alteração, divulgação ou destruição não autorizada. Os dados são armazenados em servidores seguros, com práticas de segurança consistentes com as melhores práticas do setor."),
        ("6. Direitos do Usuário","Você tem o direito de:\n- Acessar seus dados pessoais: solicitar uma cópia das informações pessoais que mantemos sobre você.\n- Corrigir ou atualizar seus dados: caso alguma informação esteja incorreta ou desatualizada. \n- Excluir suas informações: solicitar a exclusão de seus dados pessoais, incluindo redações e correções, mediante contato com nossa equipe de suporte."),
        ("7. Retenção de Dados", "Mantemos seus dados pessoais enquanto sua conta estiver ativa ou conforme necessário para cumprir nossos serviços. Após a exclusão da conta, seus dados serão removidos de nossos sistemas, salvo quando for necessário reter certas informações para cumprir requisitos legais."),
        ("8. Alterações nesta Política de Privacidade", "Podemos atualizar esta Política de Privacidade periodicamente para refletir alterações em nossas práticas ou requisitos legais. As atualizações serão notificadas no próprio aplicativo. Recomendamos que você revise esta política periodicamente para se manter informado."),
        ("9. Contato", "Em caso de dúvidas sobre esta Política de Privacidade ou sobre o tratamento de seus dados pessoais, entre em contato conosco pelo e-mail de suporte fornecido no aplicativo."),
        
    ]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                ForEach(text.indices, id: \.self) { index in
                    Text(text[index].0)
                        .bold()
                    Text(text[index].1)
                        .padding(.bottom, 30)
                }
                
            }.padding(25)
        }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Política de privacidade")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView()
}
