//
//  MeasureSizeModifier.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 16/10/24.
//

import SwiftUI

struct MeasureSizeModifier: ViewModifier {

    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background{
                GeometryReader{ geometry in
                    Color.clear
                        .onAppear {
                            callback(geometry.size)
                        }
                        .onChange(of: geometry.size) { oldValue, newValue in
                            callback(geometry.size)
                        }
                }
            }
    }
}
extension View {
    func getSize(_ callback: @escaping (CGSize) -> Void) -> some View{
        modifier(MeasureSizeModifier(callback: callback))
    }
}
