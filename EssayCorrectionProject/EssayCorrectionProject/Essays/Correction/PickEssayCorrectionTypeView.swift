//
//  SwiftUIView.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 09/10/24.
//

import SwiftUI

class EssayCorrectionViewModel: ObservableObject {
    
    @Published var correctionType = 0
    @Published var essay: String = ""
    @Published var essayTheme: String = ""
    @Published var scannedImage: UIImage?
    @Published var isScannerPresented = false
    @Published var navigateToTranscriptionReview: Bool = false
    
    static let shared = EssayCorrectionViewModel()
}

struct PickEssayCorrectionTypeView: View {
    
    @Environment(\.navigate) var navigate
    @StateObject var vm = EssayCorrectionViewModel.shared
    
    var body: some View {
        VStack {
            CorrectionSegmentedController(correctionType: $vm.correctionType)
                .padding(10)
            
            EssayThemeComponent(theme: $vm.essayTheme)
                .padding(10)
            
            EssayContainerComponent(correctionType: $vm.correctionType, text: $vm.essay, isScannerPresented: $vm.isScannerPresented)
                .padding(10)
            
                .sheet(isPresented: $vm.isScannerPresented){
                    DocumentScannerCoordinator(scannedImage: $vm.scannedImage).onDisappear(){
                        if vm.scannedImage != nil {
                            navigate(.essays(.review))
                        }
                    }
                }
        }
    }
}

#Preview {
    PickEssayCorrectionTypeView()
}
