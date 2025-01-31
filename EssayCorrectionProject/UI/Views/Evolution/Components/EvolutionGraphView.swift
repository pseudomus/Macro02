//
//  EvolutionGraphView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 13/11/24.
//

import SwiftUI

struct EvolutionGraphView: View {
    
    @Binding var failures: [CompetenceFailure]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("MÉDIA DE ERROS POR COMPETÊNCIA")
                .font(.subheadline)
                .padding(.bottom, 10)
                .padding(.top, 4)
            VStack{
                BarChart(height: 200, failures: $failures)
                    .foregroundStyle(.colorBrandSecondary500)
            }.padding()
                .background(.colorBgSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 17))
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.white)
                )
        }.padding(.horizontal)
    }
}


