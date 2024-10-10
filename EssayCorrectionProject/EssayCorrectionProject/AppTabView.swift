//
//  AppTabView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreenNavigation?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreenNavigation.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreenNavigation?)
                    .tabItem { screen.label }
            }
        }
    }
}


