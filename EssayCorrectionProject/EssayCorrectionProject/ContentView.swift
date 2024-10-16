//
//  ContentView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: AppScreenNavigation? = .essays
    
    var body: some View {
        AppTabView(selection: $selection)
            .onAppear{
                NotificationManager.instance.requestAuthorization()
            }
    }
}

#Preview {
    ContentView()
}
