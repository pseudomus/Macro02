//
//  EssayView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct EssayNavigationStack: View {
    @State var router = [HomeEssayRoute]()
    
    var body: some View {
        NavigationStack(path: $router) {
            HomeEssayView()
                .navigationDestination(for: HomeEssayRoute.self) { node in
                    node.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            if case let .essays(route) = route {
                router.append(route)
            } else if route == .back && router.count >= 1 {
                router.removeLast()
            } else if route == .popBackToRoot {
                router.removeAll()
            }
        }))
    }
}
