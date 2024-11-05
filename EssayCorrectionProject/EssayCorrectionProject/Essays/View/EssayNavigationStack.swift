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
                        router.append(.review)
                        router.removeAll(where: {$0 == .wait })
                        guard let image = essayViewModel.scannedImage else { return }
                        guard let imageData = image.jpegData(compressionQuality: 0) else { return }
                        Task {
                            do {
                                essayViewModel.transcription = try await essayViewModel.transcriptionService.makeTranscriptionRequest(imageData: imageData)
                                essayViewModel.isTranscriptionReady = true
                                guard let transcription = essayViewModel.transcription else { return }
                                essayViewModel.fullTranscribedText = transcription.joinParagraphText()
                            } catch {
                                print("deu ruim: \(error.localizedDescription)")
                                essayViewModel.transcriptionError = true
                            }
                        }
                        
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
            } else if case .profile = route {
                router.append(HomeEssayRoute.profile)
            }
        }))
    }
}
