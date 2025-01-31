//
//  DocumentScannerCoordinator.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 16/10/24.
//

import SwiftUI
import VisionKit
import WeScan

struct DocumentScannerCoordinator: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyViewController
    @EnvironmentObject var vm: EssayViewModel
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> MyViewController {
        let vc = MyViewController()
        vc.scanner.imageScannerDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        //No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, ImageScannerControllerDelegate {
        
        var parent: DocumentScannerCoordinator
        
        init(_ parent: DocumentScannerCoordinator) {
            self.parent = parent
        }
        
        func imageScannerController(_ scanner: WeScan.ImageScannerController, didFinishScanningWithResults results: WeScan.ImageScannerResults) {
            let enhancedScan = results.doesUserPreferEnhancedScan
            var image = results.croppedScan.image
            
            if enhancedScan {
                image = results.enhancedScan?.image ?? results.croppedScan.image
            }
            
            parent.vm.scannedImage = image
            scanner.dismiss(animated: true, completion: nil)
        }
        
        func imageScannerControllerDidCancel(_ scanner: WeScan.ImageScannerController) {
            scanner.dismiss(animated: true, completion: nil)
        }
        
        func imageScannerController(_ scanner: WeScan.ImageScannerController, didFailWithError error: any Error) {
            print("Scanner failed")
            scanner.dismiss(animated: true, completion: nil)
        }
    }
}
