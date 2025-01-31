//
//  RepertoireFixedFilter.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 24/10/24.
//

import SwiftData

@Model
class RepertoireFixedFilter: Identifiable {
    var isFixed: Bool = false
    var id: String
    
    init(isFixed: Bool, id: String) {
        self.isFixed = isFixed
        self.id = id
    }
}


