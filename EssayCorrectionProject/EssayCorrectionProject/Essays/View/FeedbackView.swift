//
//  FeedbackView.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 01/11/24.
//

import SwiftUI

struct FeedbackView: View {
    
    @State var feedbackText: String = ""
    @State var selectedFeedbackEmotion: String = ""
    
    var body: some View {
        VStack {
            Text("Avalie esta correção")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 30, trailing: 15))
            
            FeedbackSelectorComponent(selectedFeedbackEmotion: $selectedFeedbackEmotion)
            
            Text("Deseja enviar Feedbacks?")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 20, leading: 15, bottom: 30, trailing: 15))
            
            TextField("", text: $feedbackText, axis: .vertical)
                .padding()
                .background(Color.blue.opacity(0.5).clipShape(RoundedRectangle(cornerRadius: 10)))
                .frame(width: UIScreen.main.bounds.width * 0.95)
            
            Button {
                
            } label: {
                Text("Enviar avaliação")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .font(.title2)
                    .bold()
                    .background(Color.blue.opacity(1).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .frame(width: UIScreen.main.bounds.width * 0.95)
            }.disabled(selectedFeedbackEmotion.isEmpty)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                
            
        }
    }
}

struct FeedbackSelectorComponent: View {
    
    @State var feedbackTitle: [String] = ["Ruim", "Neutra", "Boa"]
    @Binding var selectedFeedbackEmotion: String
    
    var body: some View {
        HStack{
            ForEach(feedbackTitle, id: \.self) { feedback in
                Spacer()
                VStack {
                    Button {
                        selectedFeedbackEmotion = feedback
                    } label: {
                        Circle()
                            .fill(feedback == selectedFeedbackEmotion ? Color.black : Color.white.opacity(0))
                            .stroke(Color.black, lineWidth: 3)
                            .overlay(Text(feedback).font(.body).foregroundStyle(feedback == selectedFeedbackEmotion ? Color.white : Color.black).bold())
                    }
                    
                    Text(feedback)
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    FeedbackView()
}
