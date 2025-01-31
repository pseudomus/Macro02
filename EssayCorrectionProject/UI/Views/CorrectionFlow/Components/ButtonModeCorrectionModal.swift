//
//  ButtonModeCorrectionModal.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 31/01/25.
//

import SwiftUI

struct ButtonModeCorrectionModal: View {
    
    @Binding var mode: CorrectionMode
    var buttonMode: CorrectionMode
    @State var size: CGSize = .zero
    var withText: Bool = true
    
    var body: some View {
        VStack {
            Button{
                withAnimation {
                    mode = buttonMode
                }
            } label: {
                RoundedRectangle(cornerRadius: size.width / 5)
                    .stroke(style: .init(lineWidth: size.width / 40 ))
                    .foregroundStyle(mode == buttonMode ? .white : .colorBrandPrimary700)
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Image(buttonMode == .write ? .write : .scanner)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(mode == buttonMode ? .white : .colorBrandPrimary700)
                            .frame(width: size.width / 3)
                    }
                    .background{
                        Color.colorBrandPrimary700.opacity(mode == buttonMode ? 1 : 0)
                            .clipShape(.rect(cornerRadius: size.width / 5))
                    }
                    .padding(.vertical, 15)
            }
            
        }
        .getSize { siz in
            size = siz
        }
    }
}

