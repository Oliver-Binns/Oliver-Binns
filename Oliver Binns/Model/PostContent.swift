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

    case slider(String?, URL, URL)

    case horizontalRule

    case link(URL?, String, String, URL)
    case twitter

    case column([PostContent])
    case blank

    case cannotRender
}
extension PostContent {
    init(element: Element) throws {
        switch element.tagName() {
        case "h1":
            self = try .heading1(element.text())
        case "h2":
            self = try .heading2(element.text())
        case "h3":
            self = try .heading3(element.text())
        case "ul", "ol", "p", "blockquote":
            guard let string = try? NSMutableAttributedString(data: Data(element.html().utf8),
                                                              options: [
                                                                .documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue
                                                              ],
                                                              documentAttributes: nil) else {
                self = .cannotRender
                return
            }
            self = .body(string)
        case "figure":
            guard let src = try? element.select("img").attr("src"),
                  let url = URL(string: src) else {
                self = .cannotRender
                return
            }
            self = .figure(try? element.select("figcaption").text(), url)
        case "pre":
            self = .code(try? element.attr("title"),
                         try element.select("code").text())
        case "div":
            switch try element.className() {
            case "wp-block-group":
                let imageURLs = try element.select("img")
                    .compactMap { try? $0.attr("src") }
                    .compactMap { URL(string: $0) }
                guard imageURLs.count == 2 else {
                    self = .cannotRender
                    return
                }
                let text = try? element.select("figcaption").text()
                self = .slider(text,
                               imageURLs.first!, imageURLs.last!)
            case "wp-block-columns":
                self = .column(element.children()
                                .compactMap { $0.children().first() }
                                .compactMap {
                    try? Self(element: $0)
                })
            case "wp-block-image":
                guard let child = element.children().first() else {
                    self = .cannotRender
                    return
                }
                self = try Self(element: child)
            case _ where try element.className().contains("vlp-link-container"):
                let urlString = try element.select("a").attr("href")
                guard let url = URL(string: urlString) else {
                    self = .cannotRender
                    return
                }
                let imageURL = try element.select("img").attr("src")
                let title = try element.select(".vlp-link-title").text()
                let body = try element.select(".vlp-link-summary").text()
                self = .link(URL(string: imageURL), title, body, url)
            default:
                self = .cannotRender
            }
        case "hr":
            self = .horizontalRule
        case "a":
            let url = try element.attr("href").lowercased()
            guard url.contains("twitter") && url.contains("oliver_binns") else {
                self = .cannotRender
                return
            }
            self = .twitter
        case "script":
            self = .blank
        default:
            self = .cannotRender
        }
    }
}
