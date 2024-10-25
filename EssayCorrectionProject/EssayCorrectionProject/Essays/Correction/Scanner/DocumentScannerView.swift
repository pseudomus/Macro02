//
//  DocumentScannerView.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 16/10/24.
//

import SwiftUI
import VisionKit

struct DocumentScannerView: View {
    @State private var scannedImage: UIImage?
    @State private var isScannerPresented = false
    
    var body: some View {
        VStack {
            if let image = scannedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            Button("Scan Document") {
                isScannerPresented = true
            }
            .sheet(isPresented: $isScannerPresented) {
                DocumentScannerCoordinator(scannedImage: $scannedImage)
            }
        }
        .padding()
    }
}
