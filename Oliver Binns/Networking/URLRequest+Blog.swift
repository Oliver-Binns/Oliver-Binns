//
//  URLRequest+Blog.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import Foundation

extension URLRequest {
    private static let baseURL = "https://www.oliverbinns.co.uk/wp-json/wp/v2/"

    static var posts: URLRequest {
        .init(endpoint: "posts")
    }

    init(endpoint: String...) {
        guard let url = URL(string: Self.baseURL + endpoint.joined(separator: "/")) else {
            preconditionFailure("Expected a valid URL")
        }
        self.init(url: url)
    }
}
