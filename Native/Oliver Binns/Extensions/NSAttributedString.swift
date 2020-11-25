//
//  NSAttributedString.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import UIKit

extension NSMutableAttributedString {
    private var wholeRange: NSRange {
        .init(location: 0, length: length)
    }

    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = true) -> Self {
        let baseDescriptor = baseFont.fontDescriptor
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
        return self
    }

    func addingAttributes(_ attrs: [NSAttributedString.Key: Any],
                          range: NSRange? = nil) -> Self {
        addAttributes(attrs, range: range ?? wholeRange)
        return self
    }
}
extension NSAttributedString {
    func untilPhrase(_ phrase: String) -> NSAttributedString {
        guard let range = string.range(of: phrase, options: .backwards) else {
            return self
        }
        let nsRange = NSRange(range, in: string)
        let length = nsRange.location + nsRange.length
        return attributedSubstring(from: NSRange(location: 0, length: length))
    }

    public func trimTrailingWhiteSpace() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let endLocation = endRange?.upperBound else {
            return NSAttributedString(string: string)
        }
        let length = string.utf16.distance(from: string.utf16.startIndex, to: endLocation)
        let range = NSRange(location: 0, length: length)
        return attributedSubstring(from: range)
    }
}
