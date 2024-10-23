//
//  Endpoints.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

// ENDPOINTS
struct Endpoints {
    static let baseURL = "https://macro02-ca614ecd61ac.herokuapp.com" // academy swiftfun
    //https://macro02-ca614ecd61ac.herokuapp.com/repertoires/getAll
    static let login = "\(baseURL)/auth/login"
    static let articles = "\(baseURL)/getArticles"
    static let repertoire = "\(baseURL)/repertoires/getAll"
    static let fetchUser = "\(baseURL)/auth/fetchUser"
    static let students = "\(baseURL)/students/with-essays"
    static let essays = "\(baseURL)/students"
    static let checkGrammar = "\(baseURL)/students/checkGrammar"
}
