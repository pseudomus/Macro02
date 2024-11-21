//
//  OnboardingView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 16/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isOnOnboarding: Bool
    @State var tabViewIndex: Int = 0
    
    @State private var waveOffset = Angle(degrees: 200)
    @State private var waveHeight = 0.035
    
    var body: some View {
        ZStack {
            
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: 45, waveHeight: waveHeight)
                .fill(Color(.onboarding))
                .ignoresSafeArea(.all)
            
            TabView(selection: $tabViewIndex){
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 0).tag(0)
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 1).tag(1)
                OnboardingCardView(isOnOnboarding: $isOnOnboarding, index: 2).tag(2)
            }.tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onChange(of: tabViewIndex) {
                    switch tabViewIndex {
                    case 0:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: 200)
                            self.waveHeight = 0.035
                        }
                    case 1:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: -100)
                            self.waveHeight = 0.015
                        }
                    case 2:
                        withAnimation(.easeOut(duration: 1)) {
                            self.waveOffset = Angle(degrees: 100)
                            self.waveHeight = 0.015
                        }
                    default:
                        break
                        
                    }
                }
        }
    }
}

#Preview {
    OnboardingView(isOnOnboarding: .constant(false))
}

struct OnboardingCardView: View {
    
    @Binding var isOnOnboarding: Bool
    var index: Int
    
    var titleText: [String] = ["Comece sua jornada com Disserta", "Corrija suas redações", "Acompanhe sua evolução"]
    var bodyText: [String] = ["Pratique, evolua e conquiste a nota dos sonhos", " Tire uma foto da redação e veja a mágica acontecer com a nossa IA", "Veja gráficos personalizados de acordo com as suas redações"]
    var image: [String] = ["LapisOnboarding", "CorrigirOnboarding", "Graficos3DOnboarding"]
    
    var body: some View {
        VStack{
            Image(image[index])
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            
            Text(titleText[index])
                .font(.title3)
                .bold()
                .padding(.bottom, 20)
            
            Text(bodyText[index])
                .multilineTextAlignment(.center)
                .padding()
                .frame(width: 390)
            
        }
    }
}

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
