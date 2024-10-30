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
            Label("Essays", systemImage: "doc.plaintext")
        case .evolution:
            Label("Evolution", systemImage: "chart.line.uptrend.xyaxis.circle")
        case .repertoire:
            Label("Repertoires", systemImage: "bubble")
        case .news:
            Label("News", systemImage: "newspaper")
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
