//
//  OnboardingView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 16/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isOnOnboarding: Bool
    
    var body: some View {
        TabView{
            OnboardingCardView(isOnOnboarding: $isOnOnboarding)
            OnboardingCardView(isOnOnboarding: $isOnOnboarding)
            OnboardingCardView(isOnOnboarding: $isOnOnboarding)
        }.tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingView(isOnOnboarding: .constant(false))
}

struct OnboardingCardView: View {
    
    @Binding var isOnOnboarding: Bool

    var body: some View {
        VStack{
            Image(.borrachinha)
            Text("Oie! Tá na hora de corrigir sua primeira redação, com o tempo vamos ver seu histórico e  evolução, vamos lá?")
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                isOnOnboarding = true
            } label: {
                Text("Clique para sair do onboarding")
            }
            
            
        }
    }
}
