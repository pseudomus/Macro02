//
//  Endpoints.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 10/10/24.
//

// ENDPOINTS
struct Endpoints {
    static let baseURL = "https://macro02-ca614ecd61ac.herokuapp.com"
    static let login = "\(baseURL)/auth/login"
    static let articles = "\(baseURL)/getArticles"
    static let repertoire = "\(baseURL)/repertoires/getAll"
    static let fetchUser = "\(baseURL)/auth/fetchUser"
    static let sendEssayToCorrection = "\(baseURL)/correction"
    static let allEssays = "\(baseURL)/essay/getAll"
    static let deleteEssay = "\(baseURL)/essay/delete"
    static let transcription = "\(baseURL)/transcription"
    static let sendTransaction = "\(baseURL)/transaction"
}
