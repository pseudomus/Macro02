//
//  DocumentScannerCoordinator.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 16/10/24.
//

import SwiftUI
import VisionKit
import WeScan

//struct a: UIViewControllerRepresentable {
//    @EnvironmentObject var vm: EssayViewModel
//    @Environment(\.dismiss) var dismiss
//
//    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
//        let scannerViewController = VNDocumentCameraViewController()
//        scannerViewController.delegate = context.coordinator
//        return scannerViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
//        // No updates needed
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//        var parent: DocumentScannerCoordinator
//
//        init(_ parent: DocumentScannerCoordinator) {
//            self.parent = parent
//        }
//
//        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//            // Get the scanned image (first page)
//            let image = scan.imageOfPage(at: 0)
//            parent.vm.scannedImage = image // Pass the scanned image back to the SwiftUI view
//            
//            controller.dismiss(animated: true, completion: nil) // Dismiss the scanner
//        }
//
//        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//            controller.dismiss(animated: true, completion: nil)
//        }
//
//        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//            print("Scanning failed: \(error.localizedDescription)")
//            controller.dismiss(animated: true, completion: nil)
//        }
//    }
//}

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
            var enhancedScan = results.doesUserPreferEnhancedScan
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
