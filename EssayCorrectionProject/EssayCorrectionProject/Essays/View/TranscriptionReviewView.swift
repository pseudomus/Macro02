import SwiftUI

struct TranscriptionReviewView: View {
    
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    var body: some View {
        ZStack {
            TopBarCorrectionComponent() {
                
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
        }.toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    @Previewable @StateObject var essayViewModel = EssayViewModel()
    return TranscriptionReviewView()
          .environmentObject(essayViewModel)
}
