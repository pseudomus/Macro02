//
//  TopBarCorrectionComponent.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct TopBarCorrectionComponent: View {
    
    @Environment(\.navigate) private var navigate // Access the dismiss action
    var callback: (() -> Void)?
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        navigate(.popBackToRoot)
                        
                    }) {
                        Text("Cancelar")
                            .foregroundStyle(Color.primary)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        callback?()
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
            .alert("Tem certeza que deseja desistir?", isPresented: $isPresented) {
                
            }
            
    }
}

#Preview {
    TopBarCorrectionComponent()
}


