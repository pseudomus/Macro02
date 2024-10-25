//
//  EssayContainerComponent.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct EssayContainerComponent: View {
    
    @Binding var correctionType: Int
    @Binding var text: String
    @Binding var isScannerPresented: Bool
    
    var body: some View {
        VStack {
            BorderedContainerComponent {
                if correctionType == 0 {
                    VStack {
                        Image("scanImage")
                        Button {
                            isScannerPresented.toggle()
                        } label: {
                            Text("Escanear")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }.padding(.top, 50)
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                    
                } else if correctionType == 1 {
                    VStack{
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .frame(maxWidth: UIScreen.main.bounds.height / (2.5/3))
                        Spacer()
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height: UIScreen.main.bounds.height / 3)
                }
            }
            
            if correctionType == 1 {
                Button {
                    
                } label: {
                    Text("Confirmar")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }.padding(.top, 5)
            }
        }.frame(maxHeight: UIScreen.main.bounds.height / 2.5)
    }
}
