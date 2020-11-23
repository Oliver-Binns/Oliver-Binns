//
//  JSONDecoder.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import Foundation

extension JSONDecoder {
    convenience init(dateFormatter: DateFormatter) {
        self.init()
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
