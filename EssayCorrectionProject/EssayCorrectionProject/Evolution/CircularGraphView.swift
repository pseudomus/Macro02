//
//  CircularGraphView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 25/10/24.
//


import SwiftUI

struct CircularGraphView: View {
    
    @StateObject var data: CircularGraphData
    @State var isAnimating: Bool = false
    @State var viewSize: CGSize = .zero
    @State var lineWidth: CGFloat = 7.5
    @State var colors: [Color] = [.red, .blue, .purple]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: viewSize.width / lineWidth, lineCap: .round))
            ForEach(data.trimData.indices, id: \.self) { index in
                Circle()
                    .trim(from: data.trimData[index].start, to: isAnimating ? data.trimData[index].end - viewSize.width / lineWidth / (viewSize.width / 0.43) : 0)
                    .stroke(colors[index], style: StrokeStyle(lineWidth: viewSize.width / lineWidth, lineCap: .round))
                    .opacity(isAnimating ? 1 : 0)
                    .hoverEffect(.highlight)
                    .animation(.smooth(duration: 1.3).delay(Double(index) * 0.007), value: isAnimating)
            }
        }.padding((viewSize.width / lineWidth) / 2)
        .getSize{ size in
            viewSize = size
        }
//        .padding(100)
        .onAppear {
            if !isAnimating{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    isAnimating = true
                }
            }
        }
    }
}

class CircularGraphData: ObservableObject {
    private(set) var values: [Int]
    private(set) var percentages: [Double] = []
    @Published private(set) var trimData: [(start: Double, end: Double)] = []
    
    init(values: [Int]) {
        self.values = values
        calculateTrimValues()
    }
    
    private func calculateTrimValues() {
        let total = Double(values.reduce(0, +))
        var cumulativeValue: Double = 0
        
        for value in values {
            let percentage = Double(value) / total
            let startValue = cumulativeValue
            cumulativeValue += percentage
            let endValue = cumulativeValue
            percentages.append(percentage)
            
            trimData.append((start: startValue, end: endValue))
        }
    }
}
#Preview {
    CircularGraphView(data: CircularGraphData.init(values: [3, 5, 4]))
}
