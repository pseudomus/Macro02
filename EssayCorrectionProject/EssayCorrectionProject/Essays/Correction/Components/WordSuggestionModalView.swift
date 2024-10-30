import SwiftUI

struct WordSuggestionModalView: View {
    
    @StateObject var vm = EssayCorrectionViewModel.shared
    
    // Define grid columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()), // Adjust the number of columns as needed
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Revisão")
                    .font(.title2)
                    .bold()
                Spacer()
                Button {
                    vm.isSuggestionPresented.toggle()
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
                ForEach(vm.wordSuggestions, id: \.self) { word in
                    Button {
                        vm.isSuggestionPresented.toggle()
                    } label: {
                        Text(word)
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
        }
    }
}

#Preview {
    WordSuggestionModalView()
}

