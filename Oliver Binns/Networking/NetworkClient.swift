//
//  NetworkClient.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import Foundation

final class NetworkClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    convenience init() {
        let session = URLSession(configuration: .ephemeral)
        self.init(session: session)
    }

    enum NetworkError: Error {
        case noData
        case http(Int)
        case unknown
    }

    func executeRequest(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        return try await executeRequest(request: request)
    }

    func executeRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard response.isSuccessful else {
            print(request)
            throw NetworkError.http(response.statusCode)
        }

        return data
    }
}

extension HTTPURLResponse {
    var isSuccessful: Bool {
        (200..<300).contains(statusCode)
    }
}
