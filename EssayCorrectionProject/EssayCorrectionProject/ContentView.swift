//
//  ContentView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: AppScreenNavigation? = .essays
    @AppStorage("Onboarding") var onboarding: Bool = true
    
    var body: some View {
        if onboarding {
            OnboardingView(isOnOnboarding: $onboarding)
        } else {
            AppTabView(selection: $selection)
                .onAppear{
                    NotificationManager.instance.requestAuthorization()
                }
            
        }
    }
}

#Preview {
    ContentView()
}
