//
//  HomeEssayView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct HomeEssayView: View {
    @Environment(\.navigate) var navigate
    @State var screenSize: CGSize = .zero
    
    var body: some View {
        VStack{
            
            CustomHeaderView(title: "Redações", distanceContentFromTop: 50, showSearchBar: false, isScrollable: false) { _ in
                VStack {
                    Button {
                        navigate(.essays(.correct))
                    } label: {
                        HStack{
                            Text("Corrigir")
                                .font(.title3)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding()
                        .padding(.top, screenSize.height / 9)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal,22)
                        .padding(.bottom, 22)
                    }
                    
                    ZStack{
                        Image(.lapisinho)
                            .offset(x: -screenSize.width / 2.4)
                        
                        VStack {
                            HStack(spacing: 10) {
                                Text("--")
                                Text("Oie! Tá na hora de corrigir sua primeira redação, com o tempo vamos ver seu histórico e  evolução, vamos lá?")
                                    .font(.subheadline)
                            }.padding(.leading, screenSize.height / 7)
                                .padding(.trailing, screenSize.height / 20)
                                .offset(y: -screenSize.height / 25)
                        }
                    }
                }
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .getSize { size in
            screenSize = size
        }
        
    }
}

#Preview {
    HomeEssayView()
}

#Preview {
    ContentView()
}
