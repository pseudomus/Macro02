//
//  Endpoints.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

// ENDPOINTS
struct Endpoints {
    static let baseURL = "https://macro02-ca614ecd61ac.herokuapp.com" // academy swiftfun
    static let login = "\(baseURL)/auth/login"
    static let articles = "\(baseURL)/getArticles"
    static let fetchUser = "\(baseURL)/auth/fetchUser"
    static let students = "\(baseURL)/students/with-essays"
    static let essays = "\(baseURL)/students"
    static let sendEssayToCorrection = "\(baseURL)/correction"
}
