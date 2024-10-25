import SwiftUI

struct WordWrapView: View {
    @Binding var transcription: Transcription?
    let maxWidth: CGFloat

    var body: some View {
        GeometryReader { geometry in
            if let transcription = transcription {
                self.createLines(for: transcription.words, in: geometry.size.width)
                    .padding()
            }
        }
    }

    // Function that creates lines of HStacks
    func createLines(for words: [Word], in totalWidth: CGFloat) -> some View {
        var currentLineWidth: CGFloat = 0
        var lines: [[Word]] = [[]] // Change from [[String]] to [[Word]]

        // Set a system font size to match in calculations
        let font = UIFont.systemFont(ofSize: 16)

        for word in words {
            let wordWidth = word.text.size(usingFont: font).width + 15 // Adjust padding for Text modifiers

            if currentLineWidth + wordWidth > totalWidth {
                // Start a new line
                lines.append([word])
                currentLineWidth = wordWidth
            } else {
                // Add to the current line
                lines[lines.count - 1].append(word)
                currentLineWidth += wordWidth
            }
        }

        return VStack(alignment: .leading) {
            ForEach(0..<lines.count, id: \.self) { lineIndex in
                HStack {
                    ForEach(lines[lineIndex], id: \.text) { word in
                        Text(word.text)
                            .lineLimit(0)
                            .padding(word.confidence < 0.8 ? 5 : 0)
                            .background(word.confidence < 0.8 ? Color.red : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                print("Word: \(word.text), Confidence: \(word.confidence)")
                            }
                    }
                }
            }
        }

    }
}

extension String {
    // Helper function to calculate the size of the string
    func size(usingFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attributes)
    }
}

