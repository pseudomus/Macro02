//
//  EssayView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct EssayNavigationStack: View {
    @State var router: [HomeEssayRoute] = []
    @State var isPresented: Bool = false
    @State var isScannerPresented: Bool = false
    @Environment(\.navigate) var navigate
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    var body: some View {
        NavigationStack(path: $router) {
            HomeEssayView()
                .navigationDestination(for: HomeEssayRoute.self) { node in
                    node.destination
                }
                .sheet(isPresented: $isPresented) {
                    EssayCorrectionFlowView().interactiveDismissDisabled(true)
                }
                .fullScreenCover(isPresented: $isScannerPresented, onDismiss: {
                    if essayViewModel.scannedImage != nil {
                        router.append(.profile)
                        router.removeAll(where: {$0 == .wait })
                        
                    } else {
                        router.removeAll()
                    }
                }) {
                    DocumentScannerCoordinator()
                        .background{
                            Color.black.ignoresSafeArea()
                        }
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            if case let .essays(route) = route {
                router.append(route)
            } else if route == .back && router.count >= 1 {
                router.removeLast()
            } else if route == .popBackToRoot {
                router.removeAll()
            } else if route == .sheet {
                isPresented = true
            } else if route == .exitSheet {
                isPresented = false
            } else if route == .sheet2 {
                isScannerPresented = true
            }
        }))
    }
}
