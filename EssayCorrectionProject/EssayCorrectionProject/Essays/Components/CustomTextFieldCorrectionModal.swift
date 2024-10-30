//
//  CustomTextFieldCorrectionModal.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//

import SwiftUI

struct CustomTextFieldCorrectionModal: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text("Ex: Desafios para combater a pirataria")
            .foregroundStyle(.gray))
        .padding()
        .background(Color.gray.mix(with: .white, by: 0.8))
        .clipShape(.rect(cornerRadius: 15))
        .foregroundStyle(.gray.mix(with: .black, by: 0.5))
        .padding(.top)
    }
}
