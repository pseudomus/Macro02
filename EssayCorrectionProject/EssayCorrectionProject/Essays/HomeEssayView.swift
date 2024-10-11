//
//  HomeEssayView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI

struct HomeEssayView: View {
    @Environment(\.navigate) var navigate
    
    var body: some View {
        Button {
            navigate(.essays(.correct))
        } label: {
            Text("Go to Essay Cor")
        }
        Button {
            navigate(
                .essays(
                    .scanner(
                        text: .constant("Legal")
                    )
                )
            )
        } label: {
            Text("Go to Essay Cor")
        }
    }
}

#Preview {
    HomeEssayView()
}
