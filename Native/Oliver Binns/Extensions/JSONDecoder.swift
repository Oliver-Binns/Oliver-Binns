//
//  JSONDecoder.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import Foundation

extension JSONDecoder {
    convenience init(dateFormatter: DateFormatter) {
        self.init()
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
