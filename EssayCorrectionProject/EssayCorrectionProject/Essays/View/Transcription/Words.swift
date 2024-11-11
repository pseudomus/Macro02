//
//  Words.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 08/11/24.
//


//: [Previous](@previous)

import SwiftUI
import UIKit
import NaturalLanguage

class TranscriptionViewModel: ObservableObject {
    
    func checkMispelledWords( phrase: String) -> [Words] {
        let phraseLanguage: NLLanguage? = detectLanguage( phrase: phrase )
        var rangesOfWords: [Words] = [Words]()
        
        guard let language = phraseLanguage else { return rangesOfWords }
        
        let textChecker = UITextChecker()
        let nsString = NSString(string: phrase)
        let stringRange = NSRange(location: 0, length: nsString.length)
        var offset = 0
        
        while true {
            let wordRange = textChecker.rangeOfMisspelledWord(
                in: phrase,
                range: stringRange,
                startingAt: offset,
                wrap: false,
                language: language.rawValue)
            
            guard wordRange.location != NSNotFound else { break }
            
            let wrongWord = nsString.substring(with: wordRange)
            offset = wordRange.upperBound
            
            rangesOfWords.append( Words(range: wordRange, word: wrongWord) )
        }
        return rangesOfWords
    }
    
    func detectLanguage( phrase: String ) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(phrase)
        return recognizer.dominantLanguage
    }
    
}

struct Words {
    var range: NSRange?
    var word:  String
}
