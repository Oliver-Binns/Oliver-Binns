//
//  URL.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 28/10/2020.
//
import Foundation

extension URL {
    init(staticString: StaticString) {
        guard let url = URL (string: "\(staticString)") else {
            preconditionFailure ("Invalid static URL string: \(staticString) ")
        }
        self = url
    }

    static let businessCard = URL(staticString: "https://www.oliverbinns.co.uk/businesscard.pkpass")
    static let profileImage = URL(staticString: "https://www.oliverbinns.co.uk/img/profile.jpg")
}
