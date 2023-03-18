//
//  PostContent.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//
import Foundation

enum PostContent {
    case heading(AttributedString, Int)
    case body(AttributedString)

    case image(URL)

    case figure(String?, URL)
    case code(String)

    case slider(String?, URL, URL)

    case horizontalRule

    case link(URL?, String, String, URL)
    case twitter
    case youTube(String, AttributedString?)

    case column([PostContent])
    case blank

    case cannotRender
}
