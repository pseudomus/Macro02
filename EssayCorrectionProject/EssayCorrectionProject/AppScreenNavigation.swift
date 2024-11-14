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
            Label("Redações", systemImage: "doc.plaintext")
        case .evolution:
            Label("Evolução", systemImage: "chart.line.uptrend.xyaxis.circle")
        case .repertoire:
            Label("Repertório", systemImage: "bubble")
        case .news:
            Label("Notícias", systemImage: "newspaper")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .essays:
            EssayNavigationStack()
        case .evolution:
            EvolutionNavigationStackView()
        case .repertoire:
            RepertoireNavigationStackView()
        case .news:
            NewsNavigationStackView()
        }
    }
}
