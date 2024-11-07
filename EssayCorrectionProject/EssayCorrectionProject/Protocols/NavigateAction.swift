//
//  NavigateAction.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 10/10/24.
//
import SwiftUI

struct NavigateAction {
    typealias Action = (Route) -> ()
    let action: Action
    func callAsFunction(_ route: Route) {
        action(route)
    }
}

//Nova forma de se criar uma variável de ambiente
extension EnvironmentValues {
    @Entry var navigate = NavigateAction { _ in }
}

//struct NavigateEnvironmentKey: EnvironmentKey {
//    static var defaultValue: NavigateAction = NavigateAction { _ in }
//}
//
//extension EnvironmentValues {
//    var navigate: (NavigateAction) {
//        get { self[NavigateEnvironmentKey.self] }
//        set { self[NavigateEnvironmentKey.self] = newValue }
//    }
//}
