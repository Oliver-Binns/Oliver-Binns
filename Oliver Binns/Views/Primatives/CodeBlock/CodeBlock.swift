//
//  CodeBlock.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
//
import Sourceful
import SwiftUI

// Required since Sourceful declares a similar typealias to UIView.
typealias View = SwiftUI.View

struct CodeBlock: View {
    @State var code: String

    init(_ string: String) {
        _code = State(initialValue: Self.regexSearch(string: string) ?? "")
    }

    var body: some View {
        SourceCodeTextEditor(text: $code)
    }

    static func regexSearch(string: String) -> String? {
        let range = NSRange(location: 0, length: (string as NSString).length)
        let regex = try? NSRegularExpression(pattern: "(?<=<code lang=\".*\" class=\".*\">).*?(?=</code>)",
                                             options: [.dotMatchesLineSeparators])
        return regex?.matches(in: string, range: range).map { match in
            let start = string.index(string.startIndex, offsetBy: match.range.location)
            let end = string.index(start, offsetBy: match.range.length)
            return String(string[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
        }.first
    }
}

struct CodeBlock_Previews: PreviewProvider {
    static var previews: some View {
        CodeBlock("")
    }
}
