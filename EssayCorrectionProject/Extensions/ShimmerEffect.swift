//
//  ShimmerEffect.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 30/01/25.
//

import SwiftUI

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}

struct ShimmerEffect: ViewModifier {
    
    private var min = -0.5
    private var max = 1.5
    @State private var isAnimating: Bool = true
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack{
                    Color.white
                    Color.gray.opacity(isAnimating ? 0.4 : 0.5)
                        .animation(.easeIn(duration: 0.7).delay(0.35).repeatForever(autoreverses: true), value: isAnimating)
                    LinearGradient(
                        colors: [.gray.opacity(0.1), .gray.opacity(0.3),
                                 
                            .gray.opacity(0.4),.gray.opacity(0.3), .gray.opacity(0.1)],
                        startPoint: isAnimating ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1),
                        endPoint: isAnimating ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
                    )
                    .scaleEffect(1.7)
//                    .rotationEffect()
                    
                    .animation(.easeIn(duration: 1.4).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = false
                    }
//                    Color.white
                }.mask(content)
                
            }
    }
}
