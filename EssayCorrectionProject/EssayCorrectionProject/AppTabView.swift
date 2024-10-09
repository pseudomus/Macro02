//
//  AppTabView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case essays
    case repertoire
    case news
    
    var id: AppScreen { self }
}

extension AppScreen{
    @ViewBuilder
    var label: some View {
        switch self {
        case .essays:
            Label("Essays", systemImage: "bird")
        case .repertoire:
            Label("Repertoires", systemImage: "bird")
        case .news:
            Label("News", systemImage: "leaf")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .essays:
            ContentView()
        case .repertoire:
            ContentView()
        case .news:
            ContentView()
        }
    }
}
