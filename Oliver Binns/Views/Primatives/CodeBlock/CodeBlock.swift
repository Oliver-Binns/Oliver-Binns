//
//  CodeBlock.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
//
import SwiftUI

struct CodeBlock: View {
    var title: String?
    @State var code: String
    @State private var desiredHeight: CGFloat = 200

    init(_ string: String) {
        title = Self.regexSearch(string: string, pattern: "(?<=title=\").*?(?=\")")
        _code = State(initialValue: Self.regexSearch(string: string,
                                                     pattern: "(?<=<code lang=\"swift\" class=\"language-swift\">).*?(?=</code>)") ?? "")
    }

    var body: some View {
        VStack {
            if title != nil {
                Text(title!).font(.headline)
            }
            SourceCodeTextView(text: $code, desiredHeight: $desiredHeight)
                .frame(height: desiredHeight)
        }
    }

    static func regexSearch(string: String, pattern: String) -> String? {
        let range = NSRange(location: 0, length: (string as NSString).length)
        let regex = try? NSRegularExpression(pattern: pattern,
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
