//
//  CorrectedEssayCardView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 17/10/24.
//

import SwiftUI

struct DeletableCorrectedEssayCardView: View {
    
    @State var boxSize: CGSize = .zero
    @State var itemOffset: CGFloat = .zero
    @State var isSwiped: Bool = false
    @State var isDeleting: Bool = false
    @State var wasDeleting: Bool = false
    
    @State var title: String = "Corrected Essay Card"
    @State var description: String = "This is a corrected essay card."
    @State var dayOfCorrection: String = ""
    @State var tags: String = "Tag"
    @State var isCorrected: Bool = true
    @Binding var isScrolling: Bool
    @Binding var isDragging: Bool
    var callback: (() -> Void)?
    var delete: (() -> Void)?
    
    var body: some View {
        VStack {
            if !wasDeleting {
                ZStack {
                    Button {
                        deleteItem()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 23)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, boxSize.width / 9.8)
                        .frame(height: boxSize.height)
                        .background {
                            Color.red
                        }
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    
                    CorrectedEssayCardView(
                        title: title,
                        description: description,
                        dayOfCorrection: dayOfCorrection,
                        tags: tags,
                        isCorrected: isCorrected)
                    .getSize { size in
                        boxSize = size
                    }
                    .offset(x: itemOffset)
                    .onTapGesture {
                        callback?()
                    }
                    .animation(.spring, value: itemOffset)
                }.shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
                .padding(.horizontal)
                .contentShape(Rectangle())
                .scaleEffect(x: 1, y: isDeleting ? 0 : 1, anchor: .top)
                .opacity(isDeleting ? 0 : 1)
                .blur(radius: isDeleting ? 10 : 0)
                .animation(.spring(duration: 0.9), value: isDeleting)
                .simultaneousGesture(
                    !isScrolling ? DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)) : nil
                )
                .onChange(of: isScrolling) { oldValue, newValue in
                        if newValue == true {
                            itemOffset = 0
                        }
                    }
            }
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                itemOffset = value.translation.width - 40
            } else {
                itemOffset = value.translation.width
            }
        }
        print("Iniciou Drag")
        if value.translation.width < -30 {
            isDragging = true
        }
        
    }
    
    func onEnd(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if -value.translation.width > UIScreen.main.bounds.width / 2 {
                deleteItem()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    itemOffset = -1000
                }
            } else if -itemOffset > 50 {
                isSwiped = true
                itemOffset = -90
            } else {
                isSwiped = false
                itemOffset = 0
            }
        } else {
            isSwiped = false
            itemOffset = 0
        }
        print("Finalizou drag")
        isDragging = false
    }
    
    func deleteItem() {
        isDeleting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                wasDeleting = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                delete?()
            }
        }
    }
}

struct CorrectedEssayCardView: View {
    @State var title: String = "Corrected Essay Card"
    @State var description: String = "This is a corrected essay card."
    @State var dayOfCorrection: String
    @State var tags: String = "any"
    @State var isCorrected: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .bold()
                    .foregroundStyle(.black)
                Spacer()
            }
            Text(description)
                .lineLimit(1)
                .foregroundStyle(.black)
            HStack {
                Text(dateFormatted)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.7))
                Spacer()
                TagComponent(label: tags.captalizedSetence)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
        .overlay{
            if !isCorrected {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay {
                        Text("Corrigindo sua redação...")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                    }
            }
        }
    }
    
    
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        
        // Define o formato da data da string original (2024-10-23T21:01:10.547Z)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Converte a string para um objeto Date
        if let date = dateFormatter.date(from: dayOfCorrection) {
            
            // Cria um novo DateFormatter para extrair apenas o dia (dd)
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d" // "d" para pegar apenas o dia (sem leading zero)
            
            // Converte a data para o formato de dia
            let dayString = dayFormatter.string(from: date)
            
            return "Corrigida dia \(dayString)"
        } else {
            print("Erro ao converter a string para Date.")
        }
        
        return "" // Retorna uma string vazia caso a conversão falhe
    }
    
    
}

#Preview {
    CorrectedEssayCardView(dayOfCorrection: "2024-10-23T21:01:10.547Z")
}
