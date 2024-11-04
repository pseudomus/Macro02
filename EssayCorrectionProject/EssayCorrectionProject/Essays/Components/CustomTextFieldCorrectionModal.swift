//
//  CustomTextFieldCorrectionModal.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//

import SwiftUI

enum TextFieldMode {
    case small
    case big
}

struct CustomTextFieldCorrectionModal: View {
    @Binding var text: String
    @State var placeholderText: String
    var mode: TextFieldMode

    var body: some View {
        
        if mode == .big {
            TextField("", text: $text, prompt: Text(placeholderText)
                .foregroundStyle(.gray), axis: .vertical)
            .padding()
            .frame(minHeight: 450, alignment: .topLeading)
            .background(Color.gray)
            .clipShape(.rect(cornerRadius: 15))
            .foregroundStyle(.gray)
            
        } else {
            TextField("", text: $text, prompt: Text(placeholderText))
                .foregroundStyle(.gray)
            .padding()
            .background(Color.gray)
            .clipShape(.rect(cornerRadius: 15))
            .foregroundStyle(.gray)
        }
    }
}
