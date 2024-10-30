//
//  SwiftUIView.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 09/10/24.
//

import SwiftUI
import UIKit

class EssayCorrectionViewModel: ObservableObject {
    
    @Published var correctionType = 0
    @Published var essay: String = ""
    @Published var essayTheme: String = ""
    @Published var scannedImage: UIImage?
    @Published var isScannerPresented = false
    @Published var navigateToTranscriptionReview: Bool = false
    @Published var wordSuggestions: [String] = []
    @Published var isSuggestionPresented: Bool = false

    static let shared = EssayCorrectionViewModel()
    
    func checkSpelling(for text: String) -> [String] {
        let textChecker = UITextChecker()
        let range = NSRange(location: 0, length: text.utf16.count)
        var suggestions: [String] = []
        
        let misspelledRange = textChecker.rangeOfMisspelledWord(
            in: text,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "pt"
        )

        if misspelledRange.location != NSNotFound {
            // Get the guesses for corrections
            suggestions = textChecker.guesses(forWordRange: misspelledRange, in: text, language: "pt") ?? []
        }
        
        return suggestions
    }
    
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
