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
    @Namespace var animation
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var viewModel: HomeEssayViewModel = HomeEssayViewModel()
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Redações", distanceContentFromTop: 50, showSearchBar: false, isScrollable: !viewModel.isFirstTime, numOfItems: viewModel.essays.count) { shouldAnimate in
                
                VStack {
                    if !shouldAnimate {
                    Button {
                        navigate(.sheet)
                    } label: {
                        HStack(alignment: .bottom){
                            Text("Corrigir")
                                .font(.title3)
                                .foregroundStyle(.black)
                            Spacer(minLength: screenSize.width / 2.7)
                            if !viewModel.isFirstTime{
                                Image(.lapisinho)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .matchedGeometryEffect(id: "lapis", in: animation)
                            }
                        }
                        .padding()
                        .padding(.top,viewModel.isFirstTime ? screenSize.height / 9 : 0)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal,22)
                        .padding(.bottom, 22)
                    }
                    }
                    if viewModel.isFirstTime {
                        
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
                        ForEach(viewModel.essays, id: \.id){ essay in
                            CorrectedEssayCardView(title: essay.title, description: essay.content, dayOfCorrection: essay.creationDate)
                        }
                    }
                }
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .getSize { size in
                screenSize = size
            }
            .onAppear {
                viewModel.fetchEssays(id: "101")
            }
    }
}

#Preview {
    HomeEssayView()
}

