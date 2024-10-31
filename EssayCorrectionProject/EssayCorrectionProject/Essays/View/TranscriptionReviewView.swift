import SwiftUI

struct TranscriptionReviewView: View {
    
    @State var isTranscriptionReady: Bool = true
    @State var text: String = "Teste"
        
    var body: some View {
        ZStack {
            TopBarCorrectionComponent() // Ensure it doesn't cover the content

            VStack {
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

                if isTranscriptionReady {
                    ScrollView {
                        BorderedContainerComponent{
                            TextField("", text: $text, axis: .vertical)
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
}

#Preview {
    TranscriptionReviewView()
}
