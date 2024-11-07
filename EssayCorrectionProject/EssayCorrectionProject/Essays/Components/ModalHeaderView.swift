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
        ZStack(alignment: .center) {
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
                        .fontWeight(.light)
                        .frame(width: 28)
                        .foregroundStyle(.colorBrandPrimary700)
                        .padding(.top)
                        .padding(.trailing)
                        .padding(.trailing, 5)
//                        .padding(.top, 8)
                }
            }
        }.background(Color.colorBgPrimary)
    }
}
