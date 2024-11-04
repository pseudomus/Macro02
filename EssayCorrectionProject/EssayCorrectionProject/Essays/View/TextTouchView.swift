//
//  TextTouchView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 03/11/24.
//

import SwiftUI

struct TextTouchView: View {
    @State var isFocused = false
        @State var text = "Text"
        
        var body: some View {
            TextField("Some Text", text: $text)
                .onTapGesture {
                    isFocused = true
                }
                .onSubmit {
                    isFocused = false
                }
              
        }
}


#Preview {
    TextTouchView()
}
