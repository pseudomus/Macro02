//
//  TextTouchView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 03/11/24.
//

import SwiftUI
import UIKit

struct HighlightedTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    @State var searchTexts: [String]
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

        // Destaca todas as palavras a serem procuradas
        for searchText in searchTexts {
            print(searchText)
            if let range = text.range(of: searchText) {
                let nsRange = NSRange(range, in: text)
                
                attributedText.addAttribute(.backgroundColor, value: UIColor.red.withAlphaComponent(0.3), range: nsRange)
                attributedText.addAttribute(.underlineColor, value: UIColor.red, range: nsRange)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
                attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: nsRange)
                attributedText.addAttribute(.link, value: searchText, range: nsRange) // Usa a palavra como link
            }
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
            
            // Verifica se o link é um dos textos destacados
            if parent.searchTexts.contains(tappedText) {
                parent.onHighlightTap(tappedText) // Passa a palavra clicada
                return false // Impede a navegação padrão do link
            }
            
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            // Atualiza o valor do texto no Binding
            parent.text = textView.text
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
            parent.height = estimatedSize.height
        }
    }
}
