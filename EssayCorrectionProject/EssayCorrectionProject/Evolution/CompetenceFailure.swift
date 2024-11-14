//
//  CompetenceFailure.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 13/11/24.
//


import SwiftUI
import Charts
import Foundation

struct CompetenceFailure: Hashable{
    var errorsCount : Int
    var competency : Int

}

struct BarChart: View {
    
    @State var height: CGFloat
    @State var failures: [CompetenceFailure] = [
        CompetenceFailure(errorsCount: 34, competency: 1),
        CompetenceFailure(errorsCount: 23, competency: 2),
        CompetenceFailure(errorsCount: 12, competency: 3),
        CompetenceFailure(errorsCount: 65, competency: 4),
        CompetenceFailure(errorsCount: 30, competency: 5),
    ]
    @State var isAnimated: Bool = false
    
    var body: some View {
        VStack {
            Chart(failures, id: \.competency) { i in
                BarMark(x: .value("Compentency", "\(i.competency)"),
                        y: .value("ErrorsCount", isAnimated ? i.errorsCount : 0), width: 30)
                
                .clipShape(.rect(cornerRadii: .init(topLeading: 7, bottomLeading: 0, bottomTrailing: 0, topTrailing: 7)))
                
            }.chartYAxis {
                
                AxisMarks(position: .trailing){ val in
                    
                    if val.index == 0 {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1,
                                                         lineCap: .butt,
                                                         lineJoin: .bevel,
                                                         miterLimit: 1,
                                                         dash: [],
                                                         dashPhase: 1))
                        .foregroundStyle(.gray)
                        .offset(x: 0, y: 0.5)
                    }
                    AxisValueLabel()
                    
                }
            }.chartXAxis {
                
                AxisMarks(position: .automatic){ val in
                    
                    if val.index == 0 {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1,
                                                         lineCap: .butt,
                                                         lineJoin: .bevel,
                                                         miterLimit: 1,
                                                         dash: [],
                                                         dashPhase: 1))
                        .foregroundStyle(.gray)
                        
                    }
                    AxisValueLabel()
                    
                }
            }
            .chartYScale(domain: isAnimated ? 0...(failures.map({$0.errorsCount}).max() ?? 40) : 0...40)
            .frame(height: height)
            .aspectRatio(1, contentMode: .fit)
        }.animation(.spring(duration: 0.5), value: isAnimated)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isAnimated = true
            }
        }
    }
    
}
