import SwiftUI

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
                                HighlightedTextView(text: $essayViewModel.fullTranscribedText, height: $height) { i in
                                    isPresented = true
                                    selectedText = i
                                }
                                .frame(minHeight: (height < 400) ? 400 : height)
                                    
                            }.padding()
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
                .presentationDetents([.fraction(0.3)])
        }
        
    }

}

#Preview {
    @Previewable @StateObject var essayViewModel = EssayViewModel()
    @Previewable @StateObject var userViewModel = UserViewModel()
    return TranscriptionReviewView()
          .environmentObject(essayViewModel)
          .environmentObject(userViewModel)
}
