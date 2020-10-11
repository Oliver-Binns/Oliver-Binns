//
//  KeyedDecodingContainer.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 13/09/2020.
//
import Foundation

extension KeyedDecodingContainer {
    enum URLDecodingError: Error {
        case invalidURLString
    }

    public func decode(_ type: URL.Type,
                       forKey key: KeyedDecodingContainer<K>.Key) throws -> URL {
        let string = try self.decode(String.self, forKey: key)
        guard let url = URL(string: string) else {
            throw URLDecodingError.invalidURLString
        }
        return url
    }
}
