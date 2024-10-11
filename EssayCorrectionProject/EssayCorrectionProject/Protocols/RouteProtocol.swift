//
//  RouteProtocol.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//
import Foundation
import SwiftUI

//Enum responsável pelo gerenciamento das routers para cada navigationStack
enum Route: Hashable {
    case essays(HomeEssayRoute)
    case repertoire(HomeEssayRoute)
    case evolution(HomeEssayRoute)
    case news(HomeEssayRoute)
    case back, popBackToRoot
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .essays(let homeEssayRoute):
            homeEssayRoute.destination
        case .repertoire(let repertoireRoute):
            repertoireRoute.destination
        case .evolution(let evolutionRoute):
            evolutionRoute.destination
        case .news(let newsRoute):
            newsRoute.destination
        default:
            EmptyView()
        }
    }
}

protocol RouteProtocol: Equatable, Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
}

extension RouteProtocol {
    //Funções para permitir que a troca de view possa receber um binding
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        default:
            hasher.combine("\(self)")
        }
    }
}
