//
//  Figure.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
//
import SwiftUI

struct Figure: View {
    var url: URL?
    var caption: String?

    init(_ string: String) {
        caption = Self.regexSearch(string: string, pattern: "(?<=<figcaption>).*?(?=</figcaption>)")
        if let urlString = Self.regexSearch(string: string, pattern: "(?<=src=\").*?(?=\")") {
            self.url = URL(string: urlString)
        }
    }

    var body: some View {
        VStack {
            if url != nil {
                AsyncImage(
                    url: url!,
                    placeholder: { Image(systemName: "doc").resizable() },
                    image: { Image(uiImage: $0).resizable() }
                )
                .aspectRatio(contentMode: .fit)
            }
            if caption != nil {
                Text(caption!)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }.frame(maxWidth: .infinity)
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

struct Figure_Previews: PreviewProvider {
    static var previews: some View {
        Figure("")
    }
}
