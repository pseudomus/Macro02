//
//  ModalHeaderView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//

import SwiftUI

struct ModalHeaderView: View {
    @Environment(\.navigate) var navigate
    @Binding var index: Int
    @Binding var mode: CorrectionMode
    
    var body: some View {
        ZStack(alignment: .top) {
            ProgressBar(progressIndex: $index, mode: $mode)
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
