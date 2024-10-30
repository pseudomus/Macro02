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
    @Namespace var namespace
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                ModalHeaderView(index: $currentIndex, mode: $essayViewModel.correctionMode)
                    .padding(.bottom, 10)
                
                TabView(selection: $currentIndex) {
                    CorrectionModalBaseView(
                        title: "Tema da redação",
                        descBody: "O tema da redação influencia na correção.",
                        isActive: .constant(essayViewModel.theme != ""),
                        index: $currentIndex
                    ){
                        CustomTextFieldCorrectionModal(text: $essayViewModel.theme, mode: .small)
                            .padding(.top)
                    }
                    .tag(0)
                    
                    CorrectionModalBaseView(
                        title: "Título da redação",
                        descBody: "O título não é obrigatório na redação do ENEM, caso a sua redação não tenha título siga para a próxima etapa.",
                        isActive: .constant(essayViewModel.title != ""),
                        index: $currentIndex
                    ){
                        CustomTextFieldCorrectionModal(text: $essayViewModel.title, mode: .small)
                            .padding(.top)
                    }
                    .tag(1)
                    
                    CorrectionModalBaseView(
                        title: "Redação",
                        descBody: "Escolha a melhor opção para enviar seu texto para correção.",
                        isActive: .constant(essayViewModel.correctionMode != .none),
                        index: $currentIndex,
                        mode: essayViewModel.correctionMode
                    ){
                        lastView
                            .toolbar(.hidden, for: .tabBar)
                    } callback: {
                        if essayViewModel.correctionMode == .transciption {

                            navigate(.essays(.scanner))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0){
                                navigate(.exitSheet)
                            }
                        } else if essayViewModel.correctionMode == .write {
                            essayViewModel.sendEssayToCorrection(text: essayViewModel.text, title: essayViewModel.title, theme: essayViewModel.theme, userId: 105)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0){
                                navigate(.exitSheet)
                            }
                        }
                    }
                    .tag(2)
                    
                }.tabViewStyle(.automatic)
                
                Spacer()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
            .onChange(of: essayViewModel.isLoading) {
                navigate(.essays(.esssayCorrected(text: essayViewModel.text)))
            }
    }
    
    var writeButton: some View {
        ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .write, withText: false)
    }
    
    var trancriptButton: some View {
        ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .transciption, withText: false)
    }
    
    var lastView: some View {
        VStack {
            if (essayViewModel.correctionMode == .none) {
                HStack( spacing: 45){
                    VStack {
                        trancriptButton
                            .matchedGeometryEffect(id: "b1", in: namespace)
                        Text("Escanear texto")
                            .fontWeight(.semibold)
                    }
                    
                    VStack{
                        writeButton
                            .matchedGeometryEffect(id: "b2", in: namespace)
                        Text("Escrever texto")
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.vertical)
            } else {
                VStack{
                    HStack(spacing: 20){
                        trancriptButton
                            .matchedGeometryEffect(id: "b1", in: namespace)
                        
                        writeButton
                            .matchedGeometryEffect(id: "b2", in: namespace)
                        Spacer(minLength: 190)
                    }
                    .padding(.top)
                        if essayViewModel.correctionMode == .transciption {
                            VStack {
                                Image(.paper)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180)
                                Text("Tire uma foto da sua folha de redação e revise o texto quando for digitalizado")
                                    .multilineTextAlignment(.center)
                                    .padding(35)
                            }.padding(.top)
                        } else {
                            CustomTextFieldCorrectionModal(text: $essayViewModel.text, mode: .big)
                                .focused($isFocused)
                                .onTapGesture {
                                    if !isFocused {
                                        isFocused = true
                                    }
                                }
                        }
                }
            }
        }
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
            
        }
        .getSize { siz in
            size = siz
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
