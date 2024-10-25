//
//  CorrectionSegmentedController.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct CorrectionSegmentedController: View {
    
    @Binding var correctionType: Int
    
    var body: some View {
        Picker("Tipo de correção", selection: $correctionType) {
            Text("Escanear").tag(0)
            Text("Escrever").tag(1)
        }.pickerStyle(.segmented)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


