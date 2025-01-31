//
//  StringExtension.swift
//  EssayCorrectionProject
//
//  Created by Luca Lacerda on 21/11/24.
//

import Foundation

extension String {
    var captalizedSetence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
