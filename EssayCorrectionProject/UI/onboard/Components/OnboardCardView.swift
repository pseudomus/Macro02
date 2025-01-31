//
//  OnboardCardView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

struct OnboardingCardView: View {
    
    @Binding var isOnOnboarding: Bool
    var index: Int
    
    var titleText: [String] = ["Comece sua jornada com Disserta", "Corrija suas redações", "Acompanhe sua evolução"]
    var bodyText: [String] = ["Pratique, evolua e conquiste a nota dos sonhos", " Tire uma foto da redação e veja a mágica acontecer com a nossa IA", "Veja gráficos personalizados de acordo com as suas redações"]
    var image: [String] = ["LapisOnboarding", "CorrigirOnboarding", "Graficos3DOnboarding"]
    
    var body: some View {
        VStack {
            Spacer()
            Image(image[index])
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            
            Text(titleText[index])
                .font(.title3)
                .bold()
                .padding(.bottom, 20)
            
            Text(bodyText[index])
                .multilineTextAlignment(.center)
                .padding(.horizontal, 35)
                .padding(.vertical)
                .frame(width: 390)
            
                Button{
                    isOnOnboarding = false
                } label: {
                    Text("Começar")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background {
                            Capsule()
                                .foregroundStyle(.blue)
                        }
                }
                .padding(.top)
                .opacity(index != 2 ? 0 : 1)
            
        }.padding(.bottom, 70)
    }
}
