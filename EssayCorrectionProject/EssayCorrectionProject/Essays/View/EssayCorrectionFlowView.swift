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
    
    @EnvironmentObject var essayViewModel: EssayViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.navigate) var navigate
    @State var currentIndex: Int = 0
    @Namespace var namespace
    @FocusState var isFocused: Bool
    @State var isPresented: Bool = false
    @State private var refreshFlag = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ModalHeaderView(index: $currentIndex, mode: $essayViewModel.correctionMode)
                .padding(.bottom, 10)
                .background(Color.colorBgPrimary)
            
            TabView(selection: $currentIndex) {
                
                CorrectionModalBaseView(
                    title: "Tema da redação",
                    descBody: "O tema da redação influencia na correção.",
                    isActive: .constant(essayViewModel.theme != ""),
                    index: $currentIndex
                ){
                    CustomTextFieldCorrectionModal(text: $essayViewModel.theme, placeholderText: "Ex: Desafios para combater a pirataria", mode: .small)
                        .padding(.top)
                        .background(Color.colorBgPrimary)
                        .onAppear {
                            essayViewModel.text = ""
                            essayViewModel.title = ""
                            essayViewModel.theme = ""
                            essayViewModel.correctionMode = .none
                            essayViewModel.scannedImage = nil
                            essayViewModel.fullTranscribedText = ""
                            essayViewModel.transcriptionError = false
                            essayViewModel.isTranscriptionReady = false
                            essayViewModel.transcription = nil
                        }
                }
                .tag(0)
                
                CorrectionModalBaseView(
                    title: "Título da redação",
                    descBody: "O título não é obrigatório na redação do ENEM, caso a sua redação não tenha título siga para a próxima etapa.",
                    isActive: .constant(essayViewModel.title != ""),
                    index: $currentIndex
                ){
                    CustomTextFieldCorrectionModal(text: $essayViewModel.title, placeholderText: "Ex: Combate a pirataria...", mode: .small)
                        .padding(.top)
                }
                .tag(1)
                
                CorrectionModalBaseView(
                    title: "Redação",
                    descBody: "Escolha a melhor opção para enviar seu texto para correção.",
                    isActive: .constant(essayViewModel.correctionMode != .none),
                    index: $currentIndex,
                    mode: essayViewModel.correctionMode
                ) {
                    lastView
                        .toolbar(.hidden, for: .tabBar)
                } callback: {
                    if essayViewModel.correctionMode == .transciption {
                        navigate(.essays(.wait))
                        navigate(.exitSheet)
                        navigate(.sheet2)
                    } else if essayViewModel.correctionMode == .write {
                        guard let userId = userViewModel.user?.id else { return }
                        essayViewModel.sendEssayToCorrection(text: essayViewModel.text, title: essayViewModel.title, theme: essayViewModel.theme, userId: userId)
                        navigate(.exitSheet)
                    }
                }.animation(.spring, value: isFocused)
                    .onTapGesture {
                        if isFocused {
                            isFocused = false
                            
                        }
                    }
                    .tag(2)
                
            }.tabViewStyle(.automatic)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .bottom)
            .onChange(of: essayViewModel.isLoading) {
                navigate(.essays(.esssayCorrected(text: essayViewModel.text)))
            }.background(Color.colorBgPrimary)
    }
    
    var writeButton: some View {
        ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .write, withText: false)
    }
    
    var trancriptButton: some View {
        ButtonModeCorrectionModal(mode: $essayViewModel.correctionMode, buttonMode: .transciption, withText: false)
    }
    
    var lastView: some View {
        ScrollView {
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
                VStack {
                    HStack(spacing: 20) {
                        if !isFocused{
                            trancriptButton
                                .matchedGeometryEffect(id: "b1", in: namespace)
                            
                            writeButton
                                .matchedGeometryEffect(id: "b2", in: namespace)
                            Spacer(minLength: 190)
                        }
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
                        CustomTextFieldCorrectionModal(text: $essayViewModel.text, placeholderText: "Escreva sua redação", mode: .big)
                            .focused($isFocused)
                            .onTapGesture {
                                if !isFocused {
                                    isFocused = true
                                }
                            }
                            .scrollDisabled(true)
                        
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
                    .foregroundStyle(mode == buttonMode ? .white : .colorBrandPrimary700)
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Image(buttonMode == .write ? .write : .scanner)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(mode == buttonMode ? .white : .colorBrandPrimary700)
                            .frame(width: size.width / 3)
                    }
                    .background{
                        Color.colorBrandPrimary700.opacity(mode == buttonMode ? 1 : 0)
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
