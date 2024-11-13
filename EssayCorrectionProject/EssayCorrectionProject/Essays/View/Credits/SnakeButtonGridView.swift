//
//  SnakeButtonGridView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//

import Foundation
import SwiftUI

// MARK: - SnakeButtonGridView
struct SnakeButtonGridView: View {
    let buttonCount: Int = 12
    @State private var buttonSize: CGSize = .zero
    @State private var completedButtons: [Int: Bool] = [1: true]
    @State private var currentButton: Int = 1 // PROPAGANDA ATUAL
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(getRows().indices, id: \.self) { rowIndex in
                let row = getRows()[rowIndex]
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { buttonNumber in
                        if buttonNumber == buttonCount {
                            getGiftButton()
                        } else {
                            getButton(for: buttonNumber)
                        }
                        
                        // HORIZONTAIS
                        if buttonNumber != row.last {
                            // Verifica a direção da animação baseada no índice da fileira
                            HorizontalCircles(
                                isCompleted:
                                    (rowIndex % 2 == 0)
                                    ? buttonNumber < currentButton  //  fileiras pares
                                    : buttonNumber <= currentButton, //  fileiras ímpares
                                animateFromRight: rowIndex % 2 != 0 //  fileiras ímpares, anima da direita para a esquerda
                            )
                        }

                    }
                }
                
                // VERTICAIS
                if row.last?.isMultiple(of: 3) != nil && row.first != buttonCount {
                    VerticalCircles(alignment: row.last!.isMultiple(of: 2) ? .leading : .trailing, buttonSize: buttonSize, isCompleted: (currentButton > row.last!) && (currentButton > row.first!))
                }
            }
        }
        .padding(10)
    }
    
    // MARK: - FUNCIONTS
    func getRows() -> [[Int]] {
        return [
            [1, 2, 3],
            [6, 5, 4],
            [7, 8, 9],
            [buttonCount, 11, 10]
        ]
    }
    
    // MARK: - VIEWS
    
    // MARK: BOTÕES PARA ASSISTIR ADD
    @ViewBuilder
    func getButton(for number: Int) -> some View {
        Button {
            print("assistir ad numero \(number)")
            currentButton = number + 1
        } label: {
            Text("\(number)")
                .fontWeight(.bold)
                .frame(width: 75, height: 71)
                .background(
                    number == currentButton
                    ? Image(.adButtonReady)
                    : number < currentButton
                    ? Image(.adButtonCompleted)
                    : Image(.adButtonBlocked)
                )
                .foregroundStyle(number > currentButton ? .black : number == currentButton ? .white : Color(.secondaryLabel))
        }
        .animation(.easeInOut, value: currentButton)
        .disabled(number != currentButton)  // Apenas o botão atual é clicável
        .getSize { size in
            self.buttonSize = size
        }
    }
    
    // MARK:  BOTÃO FINAL DE RECOMPENSA
    @ViewBuilder
    func getGiftButton() -> some View {
        Button {
            // TODO: - GANHAR UM CRÉDITO
        } label: {
            // Exibindo a imagem
            Image(currentButton == buttonCount ? .unlockedGift : .lockedGift)
                .frame(width: 75, height: 65)
                .rotationEffect(
                    Angle(degrees: currentButton == buttonCount ? 10 : 0)
                )
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: currentButton)
        }
        .disabled(currentButton != buttonCount)
    }

    // MARK:  Círculos Horizontais
    @ViewBuilder
    func HorizontalCircles(isCompleted: Bool, animateFromRight: Bool) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(isCompleted ? Color(.colorBrandPrimary300) : Color(.colorFillsPrimary))
                    .scaleEffect(isCompleted ? 1.2 : 0.8)
                    .animation(
                        .bouncy(duration: 0.5)
                            .delay(animateFromRight ? Double(2 - index) * 0.4 : Double(index) * 0.4),
                        value: isCompleted
                    )
            }
        }
    }
    
    // MARK:  Círculos Verticais
    @ViewBuilder
    func VerticalCircles(alignment: Alignment, buttonSize: CGSize, isCompleted: Bool) -> some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(isCompleted ? Color.blue : Color(.colorFillsPrimary))
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.horizontal, buttonSize.width / 2)
    }
}

#Preview {
    SnakeButtonGridView()
}
