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
    @State var isFirstTime: Bool = false //Define o estado da view sobre as redações corrigidas
    @Namespace var animation
    
    var body: some View {
        VStack{
            CustomHeaderView(title: "Redações", distanceContentFromTop: 50, showSearchBar: false, isScrollable: !isFirstTime) { shouldAnimate in
                
                VStack {
                    if !shouldAnimate {
                    Button {
                        navigate(.essays(.correct))
                        withAnimation {
                            isFirstTime.toggle()
                        }
                        
                    } label: {
                        HStack(alignment: .bottom){
                            Text("Corrigir")
                                .font(.title3)
                                .foregroundStyle(.black)
                            Spacer(minLength: screenSize.width / 2.7)
                            if !isFirstTime{
                                Image(.lapisinho)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .matchedGeometryEffect(id: "lapis", in: animation)
                            }
                        }
                        .padding()
                        .padding(.top,isFirstTime ? screenSize.height / 9 : 0)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal,22)
                        .padding(.bottom, 22)
                    }
                    }
                    if isFirstTime {
                        
                        ZStack {
                            Image(.lapisinho)
                                .offset(x: -screenSize.width / 2.4)
                                .matchedGeometryEffect(id: "lapis", in: animation)
                            
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
                    else {
                        CorrectedEssayCardView()
                            .offset(x: 0, y: shouldAnimate ? -50 : 0)
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
