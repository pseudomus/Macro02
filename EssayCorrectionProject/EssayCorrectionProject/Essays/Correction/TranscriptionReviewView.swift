//
//  EssayReviewView.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct TranscriptionReviewView: View {
    
    @StateObject var vm = EssayCorrectionViewModel.shared
    @State var transcrition: Transcription?
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
                if isTranscriptionReady {
                    WordWrapView(transcription: $transcrition, maxWidth: 300)
                } else {
                    ProgressView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                guard let imageData = vm.scannedImage?.jpegData(compressionQuality: 1) else { return }
                transcrition = try await transcriptionRequest.send(imageData: imageData)
                isTranscriptionReady = true
                numberOfPossibleErrors = transcrition?.numberOfPossibleTranscriptionMistakes() ?? 0
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    TranscriptionReviewView()
}
