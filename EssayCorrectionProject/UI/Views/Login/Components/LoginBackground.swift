//
//  Login background.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/10/24.
//

import SwiftUI

struct LoginBackground: View {
    var body: some View {
        ZStack{
            VStack {
                Image("LoginRect")
                    .resizable()
                    .scaledToFill()
                //                    .ignoresSafeArea()
                    .frame(height: 710)
                    .padding(.bottom,460)
            }
            VStack {
                Image("LoginRect2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .padding(.bottom,240)
                    .padding(.trailing,50)
            }
            VStack {
                Image("Lapisinho")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 251)
                    .padding(.bottom, 420)
                    .padding(.leading, 150)
            }
        }
    }
}

#Preview {
    LoginBackground()
}
