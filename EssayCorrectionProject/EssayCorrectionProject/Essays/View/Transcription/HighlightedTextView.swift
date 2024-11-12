//
//  TextTouchView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 03/11/24.
//

import SwiftUI
import UIKit

struct HighlightedTextView: UIViewRepresentable {
    @Binding var text: String {
        didSet {
            let results = transcriptionViewModel.checkMispelledWords(phrase: text)
            
            rangeOfWords = results.map({$0.range ?? .init()})
            searchTexts = results.map({$0.word})
        }
    }
    @Binding var height: CGFloat
    @State var searchTexts: [String] = []
    @StateObject var transcriptionViewModel: TranscriptionViewModel = TranscriptionViewModel()
    @State var rangeOfWords: [NSRange] = []
    var onHighlightTap: (String) -> Void

    func makeUIView(context: Context) -> UITextView {
                
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.attributedText = createHighlightedText(from: text)
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        textView.textContainer.lineBreakMode = .byTruncatingMiddle
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let selectedRange = uiView.selectedRange // Armazena a posição atual do cursor
        uiView.attributedText = createHighlightedText(from: text)
        uiView.selectedRange = selectedRange // Restaura a posição do cursor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func createHighlightedText(from text: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let nsString = text as NSString
                
        for range in rangeOfWords {
            let nsRange = range
            let word = nsString.substring(with: nsRange)
            
            attributedText.addAttribute(.backgroundColor, value: UIColor.red.withAlphaComponent(0.3), range: nsRange)
            attributedText.addAttribute(.underlineColor, value: UIColor.red, range: nsRange)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: nsRange)
            attributedText.addAttribute(.link, value: word, range: nsRange) // Usa a palavra como link
            
        }
        
        return attributedText
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: HighlightedTextView

        init(_ parent: HighlightedTextView) {
            self.parent = parent
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            let tappedText = URL.absoluteString
            print("\(URL.absoluteString) URL TAPPED")
            
//            if parent.searchTexts.contains(tappedText) {
//                parent.onHighlightTap(tappedText)
//                return false
//            }
            
            
            return false
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
            parent.height = estimatedSize.height
            
            let results = parent.transcriptionViewModel.checkMispelledWords(phrase: parent.text)
            
            parent.rangeOfWords = results.map({$0.range ?? .init()})
            parent.searchTexts = results.map({$0.word})
        }
    }
}
