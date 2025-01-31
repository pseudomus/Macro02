//
//  Wave.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double
    var waveHeight: CGFloat
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(offSet.degrees, waveHeight)
        }
        set {
            offSet = Angle(degrees: newValue.first)
            waveHeight = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = waveHeight * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: -rect.height))
        p.addLine(to: CGPoint(x: 0, y: -rect.height))
        p.closeSubpath()
        
        return p
    }
}
