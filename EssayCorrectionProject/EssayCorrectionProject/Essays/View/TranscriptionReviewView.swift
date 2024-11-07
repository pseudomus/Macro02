import SwiftUI

/*
 } else if essayViewModel.correctionMode == .write {
     essayViewModel.sendEssayToCorrection(text: essayViewModel.text, title: essayViewModel.title, theme: essayViewModel.theme, userId: userViewModel.user?.id ?? 105)
     navigate(.exitSheet)
 }
}
.onTapGesture {
 if isFocused {
     withAnimation {
         isFocused = false
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
 */

struct TranscriptionReviewView: View {
    
    @EnvironmentObject var essayViewModel: EssayViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.navigate) var navigate
    @State var isTabBarHidden: Bool = false
    @State var isPresented: Bool = false
    @State var selectedText: String = ""
    @State var height: CGFloat = 400
    @State var wrongTranscription: String = ""
    @State var possibleErrors: [String] = []
    @State var numOfPossibleErrors: [String] = []
    
    var body: some View {
        ZStack {
            TopBarCorrectionComponent() {
                guard let userId = userViewModel.user?.id else { return }
                essayViewModel.sendEssayToCorrection(text: essayViewModel.fullTranscribedText, title: essayViewModel.title, theme: essayViewModel.theme, userId: userId)
            }

            VStack {
                
                if essayViewModel.transcriptionError {
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70)
                        Text("Erro")
                            .fontWeight(.bold)
                            .font(.title)
                        Text("Parece que algo deu errado na sua transcrição. Tente novamente mais tarde")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,30)
                            .padding(.vertical, 5)
                        Spacer()
                    }
                    
                } else {
                    HStack {
                        Text("Revise o texto")
                            .font(.title)
                        Spacer()
                    }
                    .padding()
                    .padding(.top, 80)
                    
                    Text("Erros de transcrição podem ter sido encontrados, verifique antes de corrigir")
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    if essayViewModel.isTranscriptionReady {
                        ScrollView {
                            BorderedContainerComponent {
                                HighlightedTextView(text: $essayViewModel.fullTranscribedText, height: $height, searchTexts: possibleErrors) { i in
                                    isPresented = true
                                    selectedText = i
                                }
                                .frame(minHeight: (height < 400) ? 400 : height)
                                    
                            }.padding()
                        }.onAppear {
                            possibleErrors = essayViewModel.transcription?.getPossibleTranscriptionMistakes() ?? []
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
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(isTabBarHidden ? .hidden : .visible, for: .tabBar)
        .onChange(of: essayViewModel.isLoading) {
            navigate(.essays(.esssayCorrected(text: essayViewModel.fullTranscribedText)))
            isTabBarHidden = false
        }
        .sheet(isPresented: $isPresented) {
            WordSuggestionModalView(wrongTranscription: $wrongTranscription)
        }
        
    }
}

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
            print("\(suggestedWords)")
            print("\(wrongTranscription)")
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

#Preview {
    @Previewable @StateObject var essayViewModel = EssayViewModel()
    @Previewable @StateObject var userViewModel = UserViewModel()
    return TranscriptionReviewView()
          .environmentObject(essayViewModel)
          .environmentObject(userViewModel)
}
