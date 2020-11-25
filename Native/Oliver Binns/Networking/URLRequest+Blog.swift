//
//  URLRequest+Blog.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import Foundation

extension URLRequest {
    private static let baseURL = "https://www.oliverbinns.co.uk/wp-json/wp/v2/"

    static var posts: URLRequest {
        .init(endpoint: "posts")
    }

    static func post(withSlug slug: String) -> URLRequest {
        .init(endpoint: "posts",
              queryItems: [URLQueryItem(name: "slug", value: slug)])
    }

    init(endpoint: String..., queryItems: [URLQueryItem]? = nil) {
        guard var urlComponents = URLComponents(string: Self.baseURL + endpoint.joined(separator: "/")) else {
            preconditionFailure("Expected a valid URL string")
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            preconditionFailure("Expected a valid set of query strings")
        }
        self.init(url: url)
    }
}
