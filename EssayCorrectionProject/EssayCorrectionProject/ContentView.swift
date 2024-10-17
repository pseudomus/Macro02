//
//  ContentView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: AppScreenNavigation? = .essays
    @AppStorage("Onboarding") var onboarding: Bool = false
    
    var body: some View {
        if onboarding {
            AppTabView(selection: $selection)
                .onAppear{
                    NotificationManager.instance.requestAuthorization()
                }
        } else {
            OnboardingView(isOnOnboarding: $onboarding)
        }
    }
}

#Preview {
    ContentView()
}
