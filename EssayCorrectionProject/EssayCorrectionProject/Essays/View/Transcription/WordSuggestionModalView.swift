//
//  WordSuggestionModalView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 08/11/24.
//
import SwiftUI

struct WordSuggestionModalView: View {
    
    @Environment(\.dismiss) var dismiss

    // Define grid columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()), // Adjust the number of columns as needed
        GridItem(.flexible())
    ]
    
    @State var suggestedWords: [String] = []
    @Binding var wrongTranscription: String

    var body: some View {
        VStack {
            HStack {
                Text("Revisão")
                    .font(.title2)
                    .bold()
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.gray)
                }
            }.padding()

            BorderedContainerComponent {
                Text("Erro de transcrição identificado")
                    .font(.title2)
                    .lineLimit(0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            // Use LazyVGrid to display suggestions in a grid layout
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(suggestedWords, id: \.self) { word in
                    Button {
                        dismiss()
                    } label: {
                        Text("\(word)")
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(5)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()

            Spacer()
        }.onAppear {
            suggestedWords = []
            suggestedWords = suggestCorrectedWords(to: wrongTranscription)
            print("Sugerido: \(suggestedWords)")
            print("Palavra errada: \(wrongTranscription)")
        }
    }
    
    func suggestCorrectedWords(to word: String) -> [String] {
        let textChecker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let language = "pt_BR"
        let misspelledRange = textChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        
        if misspelledRange.location != NSNotFound {
            let suggestions = textChecker.guesses(forWordRange: misspelledRange, in: word, language: language)
            return suggestions ?? []
        }
        
        return []
    }

}
