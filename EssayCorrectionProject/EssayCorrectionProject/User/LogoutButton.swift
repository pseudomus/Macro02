//
//  LogoutButton.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 24/10/24.
//

import SwiftUI

struct LogoutButton: View {
    
    var buttonTitle: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text(buttonTitle)
                    .bold()
                Spacer()
            }
        }
        .onTapGesture {
            action()
        }
        .padding()
        .background{
            Color.red.opacity(0.4)
        }
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    LogoutButton(buttonTitle: "teste", action: {print("teste")})
}