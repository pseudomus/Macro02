//
//  CreditsButton.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 04/11/24.
//

import SwiftUI

struct CreditsButton: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var storekitManager: StoreKitManager
    var body: some View {
        VStack{
            Button{
                navigate(.creditsSheet)
            } label: {
                HStack {
                    Image(systemName: "square.3.stack.3d")
                    Text("\(storekitManager.creditBalance) \(storekitManager.creditBalance == 1 ? "crédito" : "créditos")")
                }
                .padding(8)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(Color.black)
                .clipShape(.capsule)
            }
        }
    }
}


#Preview {
    CreditsButton()
        .environmentObject(StoreKitManager())
}
