//
//  EssayScannerView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//

import SwiftUI

struct EssayScannerView: View {
    @Environment(\.navigate) var navigate
    @State var tabBarIsHidden: Bool = true
    
    var body: some View {
        VStack{
            Text("Scanner View with text")
            
            Button {
                tabBarIsHidden = false
                navigate(.popBackToRoot)
            } label: {
                Text("Voltar")
            }
            .toolbar(tabBarIsHidden ? .hidden : .visible, for: .tabBar)
        }.onAppear{
            tabBarIsHidden = true
        }
    }
}

#Preview {
    EssayScannerView()
}
