//
//  EssayScannerView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

struct EssayScannerView: View {
    @Binding var text: String
    @Environment(\.navigate) var navigate
    
    var body: some View {
        Text("Scanner View with text \(text)")
        
        Button {
            navigate(.popBackToRoot)
        } label: {
            Text("Voltar")
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    EssayScannerView(text: .constant("POP"))
}
