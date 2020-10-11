//
//  PostContent.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//
import SwiftUI

enum PostContent {
    case heading1(String)
    case heading2(String)
    case heading3(String)

    case body(NSAttributedString)
    case image(URL)

    case figure(String)

    case code(String)

    case horizontalRule

    case link(String)
    case twitter

    case cannotRender
}
extension PostContent {
    static func mapContent(string: String) -> PostContent {
        if string.starts(with: "<h2") {
            return .heading2(string
                            .replacingOccurrences(of: "<h2>", with: "")
                            .replacingOccurrences(of: "</h2>", with: ""))
        } else if string.starts(with: "<h3") {
            return .heading3(string
                            .replacingOccurrences(of: "<h3>", with: "")
                            .replacingOccurrences(of: "</h3>", with: ""))
        } else if string.hasPrefix("<p") && string.hasSuffix("</p>") ||
                    string.hasPrefix("<ul>") && string.hasSuffix("</ul>") ||
                    string.hasPrefix("<ol>") && string.hasSuffix("</ol>") {
            guard let string = try? NSMutableAttributedString(data: Data(string.utf8),
                                                              options: [.documentType: NSAttributedString.DocumentType.html],
                                                              documentAttributes: nil) else {
                return cannotRender
            }
            return .body(string)
        } else if string.contains("Tweet to @Oliver_Binns") {
            return .twitter
        } else if string.contains("vlp-link-container") {
            return .link(string)
        } else if string.hasPrefix("<hr") {
            return .horizontalRule
        } else if string.hasPrefix("<pre") && string.hasSuffix("</pre>") {
            return .code(string)
        } else if string.hasPrefix("<figure") && string.hasSuffix("</figure>") {
            return .figure(string)
        }
        return .cannotRender
    }
}
