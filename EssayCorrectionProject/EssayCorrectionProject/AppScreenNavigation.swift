//
//  AppScreen.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//
import SwiftUI

enum AppScreenNavigation: Codable, Hashable, Identifiable, CaseIterable {
    case essays
    case evolution
    case repertoire
    case news
    
    var id: AppScreenNavigation { self }
}

extension AppScreenNavigation {
    @ViewBuilder
    var label: some View {
        switch self {
        case .essays:
            Label("Essays", systemImage: "text.document.fill")
        case .evolution:
            Label("Evolution", systemImage: "bird")
        case .repertoire:
            Label("Repertoires", systemImage: "bird")
        case .news:
            Label("News", systemImage: "flame")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .essays:
            EssayNavigationStack()
        case .evolution:
            EvolutionView()
        case .repertoire:
            RepertoireView()
        case .news:
            NewsView()
        }
    }
}
