//
//  FilterOption.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 26/11/24.
//

enum FilterOption: String, CaseIterable, Identifiable {
    case recent = "Mais recente"
    case old = "Mais antigo"
    
    var id: String { self.rawValue }
}
