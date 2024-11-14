//
//  SemiCircularGraphView.swift
//  Implementacao_Graph_SwiftUI
//
//  Created by Leonardo Mesquita Alves on 12/10/24.
//

import SwiftUI

struct SemiCircularGraphCardComponentView: View {
    
    //AQUI SE FAZ A INSTÂNCIA DOS VALORES DO GRÁFICO
    @StateObject var data: SemiCircularGraphData
    @State var semiCircularSize: CGSize = .zero
    @State var graphSize: CGSize = .zero
    @State var title: String
    @State var isFlipped: Bool = false
    
    init(value: Int, minValue: Int, maxValue: Int, range: (Int, Int), title: String) {
        self._data = StateObject(wrappedValue: SemiCircularGraphData(value: value, minValue: minValue, maxValue: maxValue, range: range))
        self.title = title
    }
    
    var body: some View {
        Button{
            isFlipped.toggle()
        } label: {
            ZStack() {
                ZStack(alignment: .top){
                    
                    VStack {
                        Text("\(data.value)")
                            .font(.system(size: semiCircularSize.width / 4))
                            .foregroundStyle(.colorLabelsPrimary)
                            .bold()
                        Text(title)
                            .font(.system(size: semiCircularSize.width / 9))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.colorLabelsPrimary)
                    }.offset(y: semiCircularSize.width / 3.2)
                    
                    SemiCircularGraphView(data: data)
                        .getSize { size in
                            semiCircularSize = size
                        }
                }.offset(y: semiCircularSize.width / 10)
                    .padding(.horizontal, semiCircularSize.width / 6)
                    .padding(.vertical, semiCircularSize.width / 6)
                    .background(.colorBgSecondary)
                    .clipShape(.rect(cornerRadius: semiCircularSize.width / 7))
                    .overlay {
                        VStack{
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.left.arrow.right.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: semiCircularSize.width / 6, height: semiCircularSize.width / 6)
                                    .foregroundStyle(.colorLabelsSecondary)
                            }
                            Spacer()
                        }.padding()
                        
                    }
                    .getSize { size in
                        graphSize = size
                    }
                    .rotation3DEffect(.degrees(isFlipped ? 90: 0 ), axis: (x: 0, y: 1, z: 0), perspective: 0.2)
                    .animation(isFlipped ? .linear(duration: 0.2) : .linear(duration: 0.2).delay(0.2), value: isFlipped)
                
                RoundedRectangle(cornerRadius: semiCircularSize.width / 7)
                    .foregroundStyle(.colorBgSecondary)
                    .frame(width: graphSize.width, height: graphSize.height)
                    .overlay {
                        ZStack{
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: semiCircularSize.width / 6, height: semiCircularSize.width / 6)
                                        .foregroundStyle(.colorLabelsSecondary)
                                }
                                Spacer()
                            }.padding()
                            VStack(spacing: 5){
                                Text("As redações nota 1000 variam entre")
                                    .foregroundStyle(.colorLabelsPrimary)
                                Text("\(data.range.0) e \(data.range.1)")
                                    .foregroundStyle(.colorLabelsPrimary)
                                    .fontWeight(.bold)
                            }.padding()
                        }
                    }
                    .rotation3DEffect(.degrees(isFlipped ? 0: -90), axis: (x: 0, y: 1, z: 0), perspective: 0.2)
                    .animation(isFlipped ? .linear(duration: 0.2).delay(0.2): .linear(duration: 0.2), value: isFlipped)
            }
        }
    }
}

private struct SemiCircularGraphView: View {
    
    @State var lineWidth: CGFloat = 12
    @ObservedObject var data: SemiCircularGraphData
    @State var size: CGSize = .zero
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.45, to: 1)
                .stroke(Color.pink.opacity(0.5), style: StrokeStyle(lineWidth: size.width / 13, lineCap: .round))
                .rotationEffect(.degrees(10))
            Circle()
                .trim(from: data.trimRange.0, to: data.trimRange.1)
                .stroke(Color.pink.opacity(0.8), style: StrokeStyle(lineWidth: size.width / 13, lineCap: .round))
                .rotationEffect(.degrees(10))
            
            Circle()
                .trim(from: 0.5, to: 0.50000003)
                .stroke(Color.pink, style: StrokeStyle(lineWidth: (size.width / 13) * 1.9, lineCap: .round))
                .rotationEffect(.degrees(data.rotation))
                .rotationEffect(.degrees(0))
                .getSize { size in
                    self.size = size
                }
        }
        .animation(.snappy(duration: 0.9), value: data.rotation)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                data.getRotation()
            }
        }
    }
}

class SemiCircularGraphData: ObservableObject {
    //VALOR ATUAL
    @Published private(set) var value: Int
    //MÁXIMO VALOR QUE O GRÁFICO PODE CHEGAR
    @Published private(set) var maxValue: Int
    //MENOR VALOR QUE O GRÁFICO PODE CHEGAR
    @Published private(set) var minValue: Int
    //TAMANHO DO RANGE DE VALORES CORRETOS
    @Published private(set) var range: (Int, Int)
    
    @Published private(set) var trimRange: (Double, Double) = (0.45, 0.45)
    @Published private(set) var rotation: Double = -5
    
    init(value: Int, minValue: Int, maxValue: Int, range: (Int, Int)) {
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.range = range
        update()
    }
    
    func getRotation() {
        let porcentagem1 = (Double(value) - Double(minValue)) / (Double(maxValue) - Double(minValue))
        let rotation = (porcentagem1 * 190) - 5
//        print(rotation)
        var newRotation = rotation
//        print(newRotation)
        
        if value < range.0 {
            newRotation = rotation * 0.89
        } else if value > range.1 {
            newRotation = rotation * 1.11
        } else {
            newRotation = rotation
        }
//        print(newRotation)
        
        if newRotation < -5 {
            self.rotation = -5
        } else if newRotation > 190 {
            self.rotation = 190
        } else {
            self.rotation = newRotation
        }
//        print(newRotation)
        
//        print(self.rotation)
    }
    
    func update() {
        let porcentagem2 = (Double(range.0) - Double(minValue)) / (Double(maxValue) - Double(minValue))
        let porcentagem3 = (Double(range.1) - Double(minValue)) / (Double(maxValue) - Double(minValue))
        
        trimRange.0 = porcentagem2 * 0.55 + 0.45
        trimRange.1 = porcentagem3 * 0.55 + 0.45
    }
}

#Preview {
    HStack{
        SemiCircularGraphCardComponentView(value: 450, minValue: 100, maxValue: 700, range: (400, 500), title: "Palavras")
        SemiCircularGraphCardComponentView(value: 150, minValue: 100, maxValue: 700, range: (400, 500), title: "Operadores naosioisd")
        
    }.padding(.horizontal, 0)
}

#Preview {
    SemiCircularGraphView(data: SemiCircularGraphData(value: 450, minValue: 100, maxValue: 600, range: (400, 500)))
}
