//
//  TranscriptionDecoder.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 22/10/24.
//

import Foundation

// MARK: - Transcription
// MARK: - Transcription
struct Transcription: Decodable {
    let paragraphs: [Paragraph]
    let words: [Word]
    let numberOfLines: Int
    let numberOfWords: Int
    
    func numberOfPossibleTranscriptionMistakes() -> Int {
        var numberOfPossibleMistakes = 0
        for word in self.words {
            if word.confidence < 0.3 {
                numberOfPossibleMistakes += 1
            }
        }
        return numberOfPossibleMistakes
    }
    
    // Changed to not take an external parameter
    func formatWords() -> [[FormattedWord]] {
        var formattedWords: [[FormattedWord]] = []
        
        var currentWordIndex = 0

        for paragraph in self.paragraphs {
            var paragraphWords: [FormattedWord] = []
            let wordsInParagraph = paragraph.text.split(separator: " ").map(String.init)

            for (index, word) in wordsInParagraph.enumerated() {
                guard currentWordIndex < self.words.count else { break }
                
                let correspondingWord = self.words[currentWordIndex]
                
                let isStart = (index == 0)
                let formattedWord = FormattedWord(
                    word: correspondingWord.text,
                    confidence: correspondingWord.confidence,
                    isStartOfParagraph: isStart
                )
                paragraphWords.append(formattedWord)
                
                currentWordIndex += 1
            }
            
            formattedWords.append(paragraphWords)
        }
        
        return formattedWords
    }
}


struct FormattedWord {
    let word: String
    let confidence: Double
    let isStartOfParagraph: Bool
}

// MARK: - Paragraph
struct Paragraph: Decodable {
    let text: String
    let lines: [Line]
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

// Sample Mock Data for Transcription
let mockTranscription = Transcription(
    paragraphs: [
        Paragraph(
            text: "Combined text of paragraph 1",
            lines: [
                Line(
                    boundingBox: [0, 0, 50, 0, 50, 20, 0, 20],
                    text: "Line 1 of paragraph",
                    appearance: Appearance(style: Style(name: "Bold", confidence: 0.95))
                ),
                Line(
                    boundingBox: [0, 30, 50, 30, 50, 50, 0, 50],
                    text: "Line 2 of paragraph",
                    appearance: Appearance(style: Style(name: "Italic", confidence: 0.92))
                )
            ]
        )
    ],
    words: [
        Word(boundingBox: [0, 0, 10, 0, 10, 20, 0, 20], text: "Word1", confidence: 0.98),
        Word(boundingBox: [15, 0, 25, 0, 25, 20, 15, 20], text: "Word2", confidence: 0.95)
    ],
    numberOfLines: 2,
    numberOfWords: 2
)

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


