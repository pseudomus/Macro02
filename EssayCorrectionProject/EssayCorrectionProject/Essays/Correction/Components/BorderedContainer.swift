//
//  BorderedContainer.swift
//  ViewsMacro02
//
//  Created by Bruno Teodoro on 10/10/24.
//

import SwiftUI

struct BorderedContainerComponent<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.gray.opacity(0.2)) // Light gray background
            .cornerRadius(10) // Rounded corners
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2) // Dark gray outline
            )
    }
}
