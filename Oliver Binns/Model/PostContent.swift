//
//  PostContent.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//
import Foundation
import SwiftSoup

enum PostContent {
    case heading1(String)
    case heading2(String)
    case heading3(String)

    case body(NSAttributedString)
    case image(URL)

    case figure(String?, URL)
    case code(String?, String)

    case horizontalRule

    case link(URL?, String, String, URL)
    case twitter

    case column([PostContent])

    case cannotRender
}
extension PostContent {
    static func mapContent(element: Element) throws -> PostContent {
        switch element.tagName() {
        case "h2":
            return try .heading2(element.text())
        case "h3":
            return try .heading3(element.text())
        case "ul", "ol", "p":
            guard let string = try? NSMutableAttributedString(data: Data(element.html().utf8),
                                                              options: [.documentType: NSAttributedString.DocumentType.html],
                                                              documentAttributes: nil) else {
                return cannotRender
            }
            return .body(string)
        case "figure":
            guard let src = try? element.select("img").attr("src"),
                  let url = URL(string: src) else {
                return .cannotRender
            }

            return .figure(try? element.select("figcaption").text(), url)
        case "pre":

            return .code(try? element.attr("title"),
                         try element.select("code").text())
        case "div":
            switch try element.className() {
            case "wp-block-columns":
                return .column(element.children()
                                .compactMap { $0.children().first() }
                                .compactMap {
                    try? Self.mapContent(element: $0)
                })
            case "wp-block-image":
                guard let child = element.children().first() else {
                    return .cannotRender
                }
                return try Self.mapContent(element: child)
            case _ where try element.className().contains("vlp-link-container"):
                let urlString = try element.select("a").attr("href")
                guard let url = URL(string: urlString) else {
                    return .cannotRender
                }
                let imageURL = try element.select("img").attr("src")
                let title = try element.select(".vlp-link-title").text()
                let body = try element.select(".vlp-link-summary").text()
                return .link(URL(string: imageURL), title, body, url)
            default:
                return .cannotRender
            }
        case "hr":
            return .horizontalRule
        case "a":
            let url = try element.attr("href").lowercased()
            guard url.contains("twitter") && url.contains("oliver_binns") else {
                return .cannotRender
            }
            return .twitter
        default:
            return .cannotRender
        }
    }
}
