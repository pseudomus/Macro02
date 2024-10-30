//
//  HomeEssayRoute.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

enum HomeEssayRoute: RouteProtocol {
    case correct
    case scanner(Binding<Bool>)
    case profile
    case esssayCorrected(essayResponse: EssayResponse? = nil, text: String)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .correct:
            EssayCorrectionView()
        case .scanner(let isPresented):
            DocumentScannerCoordinator(isPresented: isPresented)
                .toolbar(.hidden, for: .tabBar)
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea()
        case .profile:
            ProfileView()
        case .esssayCorrected(let essayResponse, let text):
            EssayCorrectedView(essayResponse: essayResponse, essayText: text)
        }
    }
}
