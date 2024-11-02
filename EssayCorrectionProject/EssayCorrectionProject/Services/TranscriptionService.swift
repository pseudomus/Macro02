//
//  TranscriptionDecoder.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 22/10/24.
//

import Foundation

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
    
    func joinParagraphText() -> String {
        var paragraphText: String = ""
        
        for paragraph in self.paragraphs {
            paragraphText.append(paragraph.text)
        }
        
        return paragraphText
    }
    
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

class TranscriptionService {
    private let urlSession = URLSession.shared
    private let endpoint = Endpoints.transcription

    func makeTranscriptionRequest(imageData: Data) async throws -> Transcription {
        
        guard let url = URL(string: endpoint) else {
            let errorMessage = "Invalid URL"
            print("Error response from server: \(errorMessage)")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
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
            let transcription = try decoder.decode(Transcription.self, from: data)
            print("Decoded transcription:", transcription)
            return transcription
        } catch {
            print("Failed to decode JSON. Error: \(error)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(responseString)")
            }
            throw error
        }
    }
}




