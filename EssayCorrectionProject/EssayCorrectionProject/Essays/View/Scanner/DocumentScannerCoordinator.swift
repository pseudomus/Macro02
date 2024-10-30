//
//  DocumentScannerCoordinator.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 16/10/24.
//

import SwiftUI
import VisionKit

struct DocumentScannerCoordinator: UIViewControllerRepresentable {
    @EnvironmentObject var vm: EssayViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerCoordinator
        @Environment(\.dismiss) var dismiss

        init(_ parent: DocumentScannerCoordinator) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Get the scanned image (first page)
            let image = scan.imageOfPage(at: 0)
            parent.vm.scannedImage = image // Pass the scanned image back to the SwiftUI view
            
            controller.dismiss(animated: true, completion: nil) // Dismiss the scanner
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
            dismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Scanning failed: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}





