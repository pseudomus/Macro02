//
//  ProfileButton.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 29/10/24.
//

import SwiftUI

struct ProfileButton: View {
    
    @Environment(\.navigate) var navigate
    
    var body: some View {
        VStack {
            Button {
                navigate(.profile)
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.black)
                    .frame(width: 33)
            }
        }
    }
}

#Preview {
    ProfileButton()
}
