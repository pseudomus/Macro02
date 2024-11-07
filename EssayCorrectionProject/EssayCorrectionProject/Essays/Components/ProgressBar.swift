//
//  ProgressBar.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//
import SwiftUI

struct ProgressBar: View {
    @State var viewSize: CGSize = .zero
    @State var width: CGFloat = 15
    @State var cornerRadius: CGFloat = 15
    @Binding var progressIndex: Int
    @Binding var mode: CorrectionMode
    
    var body: some View {
        HStack(spacing: width / 1.3) {
            HStack(spacing: width / 1.7) {
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 0))
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 1))
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(progressIndex >= 2))
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: .constant(mode != .none))
            }
        }.frame(height: (viewSize.width / 15) * 1.22)
            .getSize { size in
                if viewSize != .zero { return }
                viewSize = size
                width = viewSize.width / 15
                cornerRadius = viewSize.width / 10
            }
    }
}

struct ProgressBarComponent: View {
    @Binding var cornerRadius: CGFloat
    @Binding var isActive: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius / 2)
            .foregroundStyle(isActive ? .colorBrandSecondary500 : .colorBrandSecondary300)
    }
}
