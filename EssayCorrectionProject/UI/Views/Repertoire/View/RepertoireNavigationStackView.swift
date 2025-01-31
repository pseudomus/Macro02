//
//  RepertoireNavigationStackView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

struct RepertoireNavigationStackView: View {
    
    @State var baseRouter: [BaseRoute] = []
    @Environment(\.navigate) var navigate
    
    var body: some View {
        NavigationStack (path: $baseRouter){
            RepertoireView()
                .navigationDestination(for: BaseRoute.self) { node in
                    node.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            if case .profile = route {
                baseRouter.append(BaseRoute.profile)
            } else if route == .back && baseRouter.count >= 1 {
                baseRouter.removeLast()
            }
        }))
    }
}
