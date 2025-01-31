//
//  SwiftUIView.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 24/10/24.
//

import SwiftUI

struct ProfileTextBox: View {
    
    var textToShow: String
    
    var body: some View {
        VStack {
            HStack{
                Text(textToShow)
                    .bold()
                Spacer()
            }
        }
        .padding()
        .background{
            Color.white
        }
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ProfileTextBox(textToShow: "teste")
}
