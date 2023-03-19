//
//  PostContent.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//
import Foundation

indirect enum PostContent {
    case heading(AttributedString, Int)
    case body(AttributedString)

    case image(AttributedString?, String, URL)
    case code(String)

    case slider(String?, URL, URL)

    case horizontalRule

    case link(URL?, String, String, URL)
    case youTube(String, AttributedString?)

    case unorderedList([PostContent])
    case orderedList([PostContent])

    case column([PostContent])
    case blank

    case cannotRender
}
