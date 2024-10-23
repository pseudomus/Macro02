//
//  RepertoireCardView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//
import SwiftUI

struct RepertoireCardView: View {
    
    @State var author: String
    @State var descript: String
    @Binding var isPinned: Bool
    private let pasterboard = UIPasteboard.general
    
    var body: some View {
        VStack{
            HStack{
                Text(author)
                    .bold()
                Spacer()
                Button{
                    isPinned.toggle()
                } label: {
                    if isPinned{
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.black)
                    } else {
                        Image(systemName: "pin")                        .foregroundStyle(.black)
                    }
                }
            }.foregroundStyle(.black)
            
            HStack {
                Text(descript)
                Spacer()
            }
                
        }.padding()
        .background{
            Color.white
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    func copyToClipboard() {
        pasterboard.string = "\(author) \n\(descript)"
    }
}
