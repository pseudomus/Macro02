//
//  TemaRedaçãoComponent.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct EssayThemeComponent: View {
    
    @Binding var theme: String
    
    var body: some View {
        VStack {
            Text("Qual é o tema da redação?")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            BorderedContainerComponent{
                TextField("", text: $theme)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
