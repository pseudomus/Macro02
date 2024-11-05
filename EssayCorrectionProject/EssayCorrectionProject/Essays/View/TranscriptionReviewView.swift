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
    @State var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin porta ipsum ac justo rhoncus, ut pellentesque lectus venenatis. Donec iaculis enim tortor, quis gravida est tempor luctus. Nulla non neque ullamcorper, aliquet libero quis, sagittis sapien. Nam consequat metus sit amet sapien mattis porta. Vivamus pharetra efficitur enim, cursus congue quam. Pellentesque molestie massa vel tellus vehicula facilisis. Mauris eget tempor arcu.\nNulla congue sapien vitae lorem placerat consequat vitae in diam. In ullamcorper, urna vulputate feugiat tincidunt, diam sapien sodales ipsum, eu hendrerit nibh felis sed erat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vel leo ut lorem venenatis tempor. Duis vel pharetra justo. Mauris imperdiet, turpis sed posuere convallis, sapien erat commodo nisl, et euismod metus sem sit amet sem. In varius neque et massa dapibus, ut elementum risus sodales. Nunc egestas tincidunt gravida. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\nDuis at elit tempor, dictum arcu et, fringilla mi. Vestibulum et ex viverra, tempor massa in, imperdiet sapien. Proin maximus condimentum rutrum. Vivamus hendrerit ipsum in libero ultricies consequat. Nam ultrices risus tincidunt, varius risus ac, fermentum arcu. Sed in ante quis tellus elementum ullamcorper. Fusce finibus mauris non mauris ultricies consectetur."
    @State var height: CGFloat = 400
    
    var body: some View {
        ZStack {
            TopBarCorrectionComponent() {
                
                essayViewModel.sendEssayToCorrection(text: essayViewModel.fullTranscribedText, title: essayViewModel.title, theme: essayViewModel.theme, userId: userViewModel.user?.id ?? 105)
            }

            VStack {
                
//                if essayViewModel.transcriptionError {
//                    VStack(alignment: .center) {
//                        Spacer()
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 70)
//                        Text("Erro")
//                            .fontWeight(.bold)
//                            .font(.title)
//                        Text("Parece que algo deu errado na sua transcrição. Tente novamente mais tarde").padding(30)
//                        Spacer()
//                    }
//                    
//                } else {
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
                                HighlightedTextView(text: $essayViewModel.fullTranscribedText, height: $height, searchTexts: ["dolor", "amet"]) { i in
                                    isPresented = true
                                    selectedText = i
                                }.frame(minHeight: (height < 400) ? 400 : height)
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
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(isTabBarHidden ? .hidden : .visible, for: .tabBar)
        .onChange(of: essayViewModel.isLoading) {
            navigate(.essays(.esssayCorrected(text: essayViewModel.fullTranscribedText)))
            isTabBarHidden = false
        }
        .sheet(isPresented: $isPresented){
            WordSuggestionModalView()
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
