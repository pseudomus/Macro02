//
//  TagComponent.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 18/11/24.
//

import SwiftUI

enum TagCases: String, CaseIterable {
    case tag1 = "Meio ambiente"
    case tag2 = "Questões sociais"
    case tag3 = "Saúde e ciência"
    case tag4 = "Arte e cultura"
    case tag5 = "Direitos e cidadania"
    case tag6 = "Educação"
    case tag7 = "Tecnologia"
}

struct TagComponent: View {
    
    var label: String
    
    @State var backColor: Color = Color.arteECultura
    @State var labelColor: Color = .black
    
    var body: some View {
        
        VStack{
            Text(label)
                .foregroundStyle(labelColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .fontWeight(.semibold)
                .background(backColor)
                .clipShape(.capsule)
                .foregroundStyle(.black)
        }.onAppear {
            switch label {
            case TagCases.tag1.rawValue:
                self.backColor = .meioAmbiente
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag2.rawValue:
                self.backColor = .questoesSociais
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag3.rawValue:
                self.backColor = .saudeECiencia
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag4.rawValue:
                self.backColor = .arteECultura
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag5.rawValue:
                self.backColor = .direitoECidadania
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag6.rawValue:
                self.backColor = .educacao
                self.labelColor = .colorLabelsDarkPrimary
            case TagCases.tag7.rawValue:
                self.backColor = .tecnologiaEEconomia
                self.labelColor = .colorLabelsDarkPrimary
            default:
                self.backColor = .gray
            }
        }
    }
}

#Preview {
    TagComponent(label: "teste")
}
