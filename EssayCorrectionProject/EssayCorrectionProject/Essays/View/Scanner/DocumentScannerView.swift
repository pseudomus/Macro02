//
//  DocumentScannerView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 30/10/24.
//

import SwiftUI
import VisionKit

struct DocumentScannerView: View {
    
    @State var isFirtTime: Bool = true
    @Environment(\.navigate) var navigate
    
    var body: some View {
        VStack {
            Color.black.ignoresSafeArea()
                .toolbar(.hidden, for: .tabBar)
                .toolbar(.hidden, for: .navigationBar)
        }.onAppear{
            if isFirtTime {
                isFirtTime = false
            } else {
                navigate(.popBackToRoot)
            }
        }
    }
}
