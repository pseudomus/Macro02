//
//  FeedbackSelectorComponetn.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import SwiftUI

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
