//
//  LinkView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//
import Foundation
import SwiftUI

struct LinkView: View {
    var htmlString: String

    var body: some View {
        Link(destination: linkURL) {
            HStack(alignment: .top, spacing: 16) {
                if imageURL != nil {
                    AsyncImage(
                        url: imageURL!,
                        placeholder: { Image(systemName: "doc").resizable() },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(linkTitle ?? "no title")
                        .font(.headline)
                    Text(linkBody ?? "")
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .border(Color.primary)
        }
    }

    var urls: [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try! NSDataDetector(types: types.rawValue)
        return detector.matches(in: htmlString,
                                options: .reportCompletion,
                                range: NSMakeRange(0, htmlString.count))
            .compactMap {
                $0.url
            }
    }

    var linkURL: URL {
        urls.first!
    }

    var imageURL: URL? {
        urls.count > 1 ? urls[1] : nil
    }

    var linkText: [String] {
        htmlString.replacingOccurrences(of: "<[^>]+>",
                                        with: "",
                                        options: .regularExpression,
                                        range: nil).split(separator: "\t", maxSplits: 1)
            .map(String.init)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var linkTitle: String? {
        regexSearch(cssClass: "vlp-link-title")
    }

    var linkBody: String? {
        regexSearch(cssClass: "vlp-link-summary")
    }

    func regexSearch(cssClass: String) -> String? {
        let range = NSRange(location: 0, length: (htmlString as NSString).length)
        let regex = try? NSRegularExpression(pattern: "(?<=<div class=\"\(cssClass)\">).*?(?=</div>)",
                                             options: [.dotMatchesLineSeparators])
        return regex?.matches(in: htmlString, range: range).map { match in
            let start = htmlString.index(htmlString.startIndex, offsetBy: match.range.location)
            let end = htmlString.index(start, offsetBy: match.range.length)
            return String(htmlString[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
        }.first
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(htmlString: "")
    }
}
