//
//  ProgressBar.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//
import SwiftUI

struct ProgressBar: View {
    @State var viewSize: CGSize = .zero
    @State var cornerRadius: CGFloat = 13
    @Binding var progressIndex: Int
    
    var body: some View {
        HStack(spacing: cornerRadius / 1.3) {
            HStack(spacing: cornerRadius / 1.3) {
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 0))
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 1))
            }
            .frame(width: cornerRadius * 9)
            HStack(spacing: cornerRadius / 2.4) {
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 2))
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 3))
            }
        }.frame(height: (viewSize.width / 15) * 1.2)
            .getSize { size in
                if viewSize != .zero { return }
                viewSize = size
                cornerRadius = viewSize.width / 15
            }
    }
}

struct ProgressBarComponent: View {
    @Binding var cornerRadius: CGFloat
    @Binding var isActive: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius / 2)
            .foregroundStyle(isActive ? .blue.mix(with: .green, by: 0.45).mix(with: .black, by: 0.25) : .gray.mix(with: .white, by: 0.6))
    }
}
