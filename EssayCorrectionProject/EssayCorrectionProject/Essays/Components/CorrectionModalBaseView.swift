//
//  CorrectionModalBaseView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 29/10/24.
//
import SwiftUI

struct CorrectionModalBaseView<Content: View>: View {
    
    @State var title: String
    @State var descBody: String
    @Binding var isActive: Bool
    @Binding var index: Int
    var mode: CorrectionMode = .none
    
    var label: () -> Content
    var callback: (() -> Void)?
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .padding(.horizontal)
                Text(descBody)
                    .bold()
                    .padding(.horizontal)
                
                label()
                    .padding(.horizontal)
                
                if !(mode == .write) {
                    VStack {
                        button
                            .matchedGeometryEffect(id: "i", in: namespace)
                    }
                }
            }
            
            if mode == .write {
                VStack{
                    Spacer()
                    button
                        .matchedGeometryEffect(id: "i", in: namespace)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .ignoresSafeArea()
    }
    
    var button: some View {
        HStack {
            Spacer()
            Button{
                changePosition(.next)
                callback?()
            } label: {
                ZStack{
                    Image(systemName: "arrowshape.right.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(isActive ? .blue.mix(with: .green, by: 0.45).mix(with: .black, by: 0.25) : .gray.mix(with: .white, by: 0.5))
                        .frame(width: 36)
                        .padding(.trailing, 5)
                        .padding(.top)
                        .padding(.top, 3)
                }.padding(.horizontal)
                    .padding(.bottom, 35)
            }.disabled(!isActive)
        }.background{
            LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                .blur(radius: 3.5)
        }
    }
    
    func changePosition(_ position: Indexes) {
            let newIndex: Int
            
            if position == .back {
                newIndex = index - 1
            } else {
                newIndex = index + 1
            }
            
            guard newIndex >= 0, newIndex <= 2 else {
                print("Entrou na excessão \(newIndex)")
                return
            }
            
            index = newIndex
        
    }
}

enum Indexes: CaseIterable {
    case back, next
}
