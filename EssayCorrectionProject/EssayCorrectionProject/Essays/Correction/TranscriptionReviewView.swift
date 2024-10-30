//
//  EssayReviewView.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct TranscriptionReviewView: View {
    
    @StateObject var vm = EssayCorrectionViewModel.shared
    @State var transcription: Transcription?
    @State var isTranscriptionReady: Bool = false
    @State var numberOfPossibleErrors: Int = 0
    private var transcriptionRequest = TranscriptionRequest()
    
    var body: some View {
        ZStack {
            TopBarCorrectionComponent()
            VStack {
                HStack {
                    Text("Revise o texto")
                        .font(.title)
                    Spacer()
                    NumberOfErrorsComponent(numberOfErrors: $numberOfPossibleErrors)
                }.padding()
                    .padding(.top, 80)
                Text("Erros de transcrição podem ter sido encontrados, verifique antes de corrigir")
                    .font(.body)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                if isTranscriptionReady {
                    ScrollView {
                        BorderedContainerComponent{
                            WordWrapView(transcription: $transcription, maxWidth: 350)
                        }
                        .frame(maxWidth: 450)
                        .padding()
                    }
                } else {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $vm.isSuggestionPresented){
            WordSuggestionModalView()
                .presentationDetents([.medium, .fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                guard let imageData = vm.scannedImage?.jpegData(compressionQuality: 1) else { return }
                transcription = try await transcriptionRequest.send(imageData: imageData)
                isTranscriptionReady = true
                numberOfPossibleErrors = transcription?.numberOfPossibleTranscriptionMistakes() ?? 0
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    TranscriptionReviewView()
}
