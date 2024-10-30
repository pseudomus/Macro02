import SwiftUI

struct WordWrapView: View {
    
    @Binding var transcription: Transcription?
    let maxWidth: CGFloat

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if let transcription = transcription {
                    self.createLines(for: transcription.words, in: maxWidth)
                        .padding()
                }
            }
            .frame(maxWidth: maxWidth)
        }
    }

    func createLines(for words: [Word], in totalWidth: CGFloat) -> some View {
        var currentLineWidth: CGFloat = 0
        var lines: [[Word]] = [[]]

        let font = UIFont.systemFont(ofSize: 16)

        for word in words {
            let wordWidth = word.text.size(usingFont: font).width + 15
            if currentLineWidth + wordWidth > totalWidth {
                
                lines.append([word])
                currentLineWidth = wordWidth
            } else {

                lines[lines.count - 1].append(word)
                currentLineWidth += wordWidth
            }
        }

        return VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<lines.count, id: \.self) { lineIndex in
                HStack(spacing: 0) {
                    ForEach(lines[lineIndex].indices) { word in
                        Text(lines[lineIndex][word].text)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                            .overlay(lines[lineIndex][word].confidence < 0.3 ? Color.red.opacity(0.5) : Color.clear)
                            .contentShape(Rectangle())
                            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                            .onTapGesture {
                                print("Word: \(lines[lineIndex][word].text), Confidence: \(lines[lineIndex][word].confidence)")
                                EssayCorrectionViewModel.shared.isSuggestionPresented.toggle()
                                EssayCorrectionViewModel.shared.wordSuggestions = EssayCorrectionViewModel.shared.checkSpelling(for: lines[lineIndex][word].text)
                            }
                    }
                }.layoutPriority(1)
            }
        }

    }
}

extension String {
    func size(usingFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attributes)
    }
}


//import SwiftUI
//
//struct WordWrapView: View {
//    @Binding var transcription: Transcription?
//    let maxWidth: CGFloat
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(alignment: .leading) {
//                if let transcription = transcription {
//                    self.createLines(for: transcription.formatWords(), in: maxWidth)
//                        .padding()
//                }
//            }
//            .frame(maxWidth: maxWidth)
//        }.onAppear(){
//            print(transcription?.paragraphs.count)
//        }
//    }
//
//    func createLines(for formattedWords: [[FormattedWord]], in totalWidth: CGFloat) -> some View {
//        var currentLineWidth: CGFloat = 0
//        var lines: [[FormattedWord]] = [[]]
//
//        let font = UIFont.systemFont(ofSize: 16)
//
//        for paragraph in formattedWords {
//            // Add spacing for the first word of the paragraph
//            if let firstWord = paragraph.first {
//                let spacing = "   "
//                let spacingWidth = spacing.size(usingFont: font).width
//                currentLineWidth += spacingWidth
//                
//                // Check if adding the spacing and the first word exceeds the total width
//                if currentLineWidth + firstWord.word.size(usingFont: font).width > totalWidth {
//                    lines.append([]) // Start a new line
//                    currentLineWidth = 0 // Reset current line width
//                }
//                lines[lines.count - 1].append(FormattedWord(word: spacing, confidence: 1.0, isStartOfParagraph: false)) // Add spacing as a word
//            }
//
//            // Add words in the paragraph to lines
//            for word in paragraph {
//                let wordWidth = word.word.size(usingFont: font).width + 15
//                if currentLineWidth + wordWidth > totalWidth {
//                    lines.append([word]) // Start a new line with the current word
//                    currentLineWidth = wordWidth
//                } else {
//                    lines[lines.count - 1].append(word) // Add word to current line
//                    currentLineWidth += wordWidth
//                }
//            }
//            // Add a line break after finishing a paragraph
//            lines.append([]) // This adds an empty line to create a break after the paragraph
//            currentLineWidth = 0 // Reset width for the new paragraph
//        }
//
//        return VStack(alignment: .leading, spacing: 0) {
//            ForEach(0..<lines.count, id: \.self) { lineIndex in
//                HStack(spacing: 0) {
//                    ForEach(lines[lineIndex], id: \.word) { word in
//                        if word.word == "   " {
//                            // Add the spacing without creating a visual word
//                            Spacer(minLength: 15) // Add spacer for visual spacing
//                        } else {
//                            Text(word.word)
//                                .lineLimit(1)
//                                .fixedSize(horizontal: true, vertical: true)
//                                .padding(2)
//                                .overlay(word.confidence < 0.8 ? Color.red.opacity(0.5) : Color.clear)
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    print("Word: \(word.word), Confidence: \(word.confidence)")
//                                }
//                        }
//                    }
//                }.layoutPriority(1)
//            }
//        }
//    }
//}
//
//extension String {
//    func size(usingFont font: UIFont) -> CGSize {
//        let attributes = [NSAttributedString.Key.font: font]
//        return (self as NSString).size(withAttributes: attributes)
//    }
//}

