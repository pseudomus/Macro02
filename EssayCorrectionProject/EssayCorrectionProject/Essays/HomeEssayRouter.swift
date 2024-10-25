//
//  HomeEssayRoute.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

enum HomeEssayRoute: RouteProtocol {
    case correct
    case review
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .correct:
            EssayCorrectionView()
        case .review:
            TranscriptionReviewView()
        }
    }
}
