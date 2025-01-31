//
//  OnboardingView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 16/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isOnOnboarding: Bool
    @State var tabViewIndex: Int = 0
    
    @State private var waveOffset = Angle(degrees: 200)
    @State private var waveHeight = 0.035
    
    var body: some View {
        ZStack {
            
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: 45, waveHeight: waveHeight)
                .fill(Color(.onboarding))
                .ignoresSafeArea(.all)
            
            TabView(selection: $tabViewIndex){
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 0).tag(0)
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 1).tag(1)
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 2).tag(2)
            }.tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onChange(of: tabViewIndex) {
                    switch tabViewIndex {
                    case 0:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: 200)
                            self.waveHeight = 0.035
                        }
                    case 1:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: -100)
                            self.waveHeight = 0.015
                        }
                    case 2:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: 100)
                            self.waveHeight = 0.015
                        }
                    default:
                        break
                        
                    }
                }
        }
    }
}

#Preview {
    OnboardingView(isOnOnboarding: .constant(false))
}

