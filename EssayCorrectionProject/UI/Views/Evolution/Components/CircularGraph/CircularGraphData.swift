//
//  CircularGraphData.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

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
