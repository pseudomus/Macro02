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

    
    var body: some View {
        ZStack {
            TopBarCorrectionComponent() {
                essayViewModel.sendEssayToCorrection(text: essayViewModel.fullTranscribedText, title: essayViewModel.title, theme: essayViewModel.theme, userId: userViewModel.user?.id ?? 105)
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
                        Text("Parece que algo deu errado na sua transcrição. Tente novamente mais tarde").padding(30)
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
                            BorderedContainerComponent{
                                TextField("", text: $essayViewModel.fullTranscribedText, axis: .vertical)
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
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: essayViewModel.isLoading) {
            navigate(.essays(.esssayCorrected(text: essayViewModel.fullTranscribedText)))
        }
    }
}

#Preview {
    @Previewable @StateObject var essayViewModel = EssayViewModel()
    return TranscriptionReviewView()
          .environmentObject(essayViewModel)
}
