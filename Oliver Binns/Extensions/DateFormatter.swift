//
//  DateFormatter.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//

import Foundation

extension DateFormatter {
    static let humanReadable: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
