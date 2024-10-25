//
//  TranscriptionDecoder.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 22/10/24.
//

import Foundation

// MARK: - Transcription
struct Transcription: Decodable {
    let lines: [Line]
    let words: [Word]
    let numberOfLines: Int
    let numberOfWords: Int
    
    func numberOfPossibleTranscriptionMistakes() -> Int {
        
        var numberOfPossibleMistakes = 0
        
        for word in self.words {
            if word.confidence < 0.8 {
                numberOfPossibleMistakes += 1
            }
        }
        
        return numberOfPossibleMistakes
    }
}

// MARK: - Line
struct Line: Decodable {
    let boundingBox: [Int]
    let text: String
    let appearance: Appearance
}

// MARK: - Appearance
struct Appearance: Decodable {
    let style: Style
}

// MARK: - Style
struct Style: Decodable {
    let name: String
    let confidence: Double
}

// MARK: - Word
struct Word: Decodable {
    let boundingBox: [Int]
    let text: String
    let confidence: Double
}

import Foundation

class TranscriptionRequest {
    private let urlSession = URLSession.shared
    private let endpoint = Endpoints.transcriptionRequest

    func send(imageData: Data) async throws -> Transcription {
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = imageData
        
        
        let (data, response) = try await urlSession.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Error response from server: \(errorMessage)")
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Transcription.self, from: data)
        } catch {
            print("Failed to decode JSON: \(error)")
            throw error
        }
    }
}


