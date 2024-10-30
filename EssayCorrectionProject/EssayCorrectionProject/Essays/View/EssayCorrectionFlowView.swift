//
//  EssayCorrectionFlowView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 28/10/24.
//

import SwiftUI

enum CorrectionMode: String{
    case transciption = "Escanear texto"
    case write = "Escrever Texto"
    case none
}

struct EssayCorrectionFlowView: View {
    
    @StateObject var essayViewModel = EssayViewModel()
    @Environment(\.navigate) var navigate
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                ModalHeaderView(index: $currentIndex)
                    .padding(.bottom, 10)
                
                TabView(selection: $currentIndex){
                    CorrectionModalBaseView(
                        title: "Tema da redação",
                        descBody: "O tema da redação influencia na correção.",
                        isActive: .constant(essayViewModel.theme != ""),
                        index: $currentIndex
                    ){
                        CustomTextFieldCorrectionModal(text: $essayViewModel.theme)
                    }
                    .tag(0)
                    
                    CorrectionModalBaseView(
                        title: "Título da redação",
                        descBody: "O título não é obrigatório na redação do ENEM, caso a sua redação não tenha título siga para a próxima etapa.",
                        isActive: .constant(essayViewModel.title != ""),
                        index: $currentIndex
                    ){
                        CustomTextFieldCorrectionModal(text: $essayViewModel.title)
                    }
                    .tag(1)
                    
                    CorrectionModalBaseView(
                        title: "Redação",
                        descBody: "Escolha a melhor opção para enviar seu texto para correção.",
                        isActive: .constant(essayViewModel.correctionMode != .none),
                        index: $currentIndex
                    ){
                        HStack( spacing: 45){
                            ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .transciption)
                            
                            ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .write)
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                    .tag(2)
                    
                    CorrectionModalBaseView(
                        title: "Redação",
                        descBody: "Escolha a melhor opção para enviar seu texto para correção.",
                        isActive: .constant(essayViewModel.correctionMode == .transciption ? true : essayViewModel.text != ""),
                        index: $currentIndex,
                        mode: essayViewModel.correctionMode
                    ){
                        VStack{
                            HStack(spacing: 20){
                                ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .transciption, withText: false)
                                
                                ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .write, withText: false)
                                Spacer(minLength: 190)
                            }
                            .padding(.top)
                            
                            if essayViewModel.correctionMode == .transciption {
                                Image(.gabigolPlaceholder)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(.rect(cornerRadius: 20))
                            } else {
                                
                            }
                            
                        }
                        
                    } callback: {
//                        essayViewModel.sendEssayToCorrection()
                        navigate(.essays(.scanner))
                    }
                    .tag(3)
                    
                }.tabViewStyle(.automatic)
                
                Spacer()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
    }
}

#Preview {
    EssayCorrectionFlowView()
}

struct ButtonModeCorrectionModal: View {
    
    @Binding var mode: CorrectionMode
    var buttonMode: CorrectionMode
    @State var size: CGSize = .zero
    var withText: Bool = true
    
    var body: some View {
        VStack {
            Button{
                withAnimation {
                    mode = buttonMode
                }
            } label: {
                RoundedRectangle(cornerRadius: size.width / 5)
                    .stroke(style: .init(lineWidth: size.width / 40 ))
                    .foregroundStyle(mode == buttonMode ? .white : .blue.mix(with: .green, by: 0.45).mix(with: .black, by: 0.25))
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Image(buttonMode == .write ? .write : .scanner)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(mode == buttonMode ? .white : .blue.mix(with: .green, by: 0.45).mix(with: .black, by: 0.25))
                            .frame(width: size.width / 3)
                    }
                    .background{
                        Color.blue.mix(with: .green, by: 0.45).mix(with: .black, by: 0.25).opacity(mode == buttonMode ? 1 : 0)
                            .clipShape(.rect(cornerRadius: size.width / 5))
                    }
                    .padding(.vertical, 15)
            }
            if withText {
                Text(buttonMode.rawValue)
                    .fontWeight(.semibold)
            }
        }
            .getSize { siz in
                size = siz
            }
    }
}
