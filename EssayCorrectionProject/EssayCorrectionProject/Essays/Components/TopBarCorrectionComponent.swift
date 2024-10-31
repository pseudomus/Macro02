//
//  TopBarCorrectionComponent.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct TopBarCorrectionComponent: View {
    
    @Environment(\.dismiss) private var dismiss // Access the dismiss action
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                            .foregroundStyle(Color.primary)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Text("Corrigir")
                            .bold()
                            .foregroundStyle(Color.primary)
                    }
                    .padding(.trailing)
                }.padding(.bottom, 10)
            }
            .frame(height: UIScreen.main.bounds.height * 0.13)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
            Spacer()
        }.ignoresSafeArea()
    }
}

#Preview {
    TopBarCorrectionComponent()
}

