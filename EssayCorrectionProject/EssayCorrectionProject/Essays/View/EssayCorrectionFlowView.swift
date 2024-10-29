//
//  EssayCorrectionFlowView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 28/10/24.
//

import SwiftUI

struct EssayCorrectionFlowView: View {
    
    @Environment(\.navigate) var navigate
    @State var index: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            ModalHeaderView(index: $index)
                .padding(.bottom, 10)
            
            TabView(selection: $index){
                ExtractedView()
                    .tag(0)
                ExtractedView()
                    .tag(1)
                ExtractedView()
                    .tag(2)
                    .foregroundStyle(.red)
                ExtractedView()
                    .tag(3)
            }.tabViewStyle(.automatic)
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
    }
}

#Preview {
    EssayCorrectionFlowView()
}

struct ProgressBar: View {
    @State var showSheet: [Bool] = [true, false, false, false]
    @State var viewSize: CGSize = .zero
    @State var cornerRadius: CGFloat = 13
    @Binding var progressIndex: Int {
        didSet {
            for n in 0...progressIndex {
                if showSheet[n] {
                    showSheet[n] = true
                }
            }
            
            for n in (progressIndex + 1)...3 {
                if showSheet[n] {
                    showSheet[n] = false
                }
            }
        }
    }
    
    var body: some View {
        HStack(spacing: cornerRadius / 1.3) {
            HStack(spacing: cornerRadius / 1.3) {
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: $showSheet[0])
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: $showSheet[1])
            }
            .frame(width: cornerRadius * 9)
            HStack(spacing: cornerRadius / 2.4) {
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: $showSheet[2])
                ProgressBarComponent(cornerRadius: $cornerRadius, isActive: $showSheet[3])
            }
        }.frame(width: .infinity, height: cornerRadius * 1.2)
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

struct ModalHeaderView: View {
    @Environment(\.navigate) var navigate
    @Binding var index: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            ProgressBar(progressIndex: $index)
                .padding(.horizontal, 120)
                .padding(.top, 18)
            
            HStack {
                Spacer()
            Button {
                navigate(.exitSheet)
            } label: {
                
                    
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19)
                
                .padding(.top)
                .padding(.trailing)
                    .padding(.top, 8)
            }
            }
        }
    }
}

struct ExtractedView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tema da redação")
                .font(.title2)
            Text("O tema da redação influencia na correção.")
                .bold()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
