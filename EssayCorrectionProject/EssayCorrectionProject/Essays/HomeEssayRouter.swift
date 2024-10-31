//
//  HomeEssayRoute.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

enum HomeEssayRoute: RouteProtocol {
    case correct
    case scanner
    case profile
    case wait
    case esssayCorrected(essayResponse: EssayResponse? = nil, text: String)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .correct:
            EssayCorrectionView()
        case .scanner:
            EmptyView()
        case .profile:
            ProfileView()
        case .wait:
            DocumentScannerView()
                .ignoresSafeArea(.all)
        case .esssayCorrected(let essayResponse, let text):
            EssayCorrectedView(essayResponse: essayResponse, essayText: text)
        }
    }
}
