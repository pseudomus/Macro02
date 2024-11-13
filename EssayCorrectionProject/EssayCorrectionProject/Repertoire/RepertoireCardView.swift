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
    @State var isPinned: Bool = false
    private let pasterboard = UIPasteboard.general
    @State var pinnedFunction: (() -> Bool)
    
    var body: some View {
        VStack{
            HStack{
                Text(author)
                    .bold()
                Spacer()
                Button{
                    isPinned = pinnedFunction()
                } label: {
                    if isPinned{
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.black)
                    } else {
                        Image(systemName: "pin")
                            .foregroundStyle(.black)
                    }
                }
            }.foregroundStyle(.black)
            
            HStack {
                Text(descript)
                Spacer()
            }
                
        }.padding()
        .background{
            Color.colorBgSecondary
        }
        .clipShape(.rect(cornerRadius: 10))
        .onAppear{
            isPinned = pinnedFunction()
        }
    }
    
    func copyToClipboard() {
        pasterboard.string = "\(author) \n\(descript)"
    }
}
