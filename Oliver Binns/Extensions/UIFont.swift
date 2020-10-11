//
//  UIFont.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import UIKit

extension UIFont {
    static var body: UIFont {
        preferredFont(forTextStyle: .body)
    }

    static var serifBody: UIFont {
        .init(style: .body, weight: .regular, design: .serif)
    }

    fileprivate convenience init(style: TextStyle,
                                 weight: Weight = .regular,
                                 design: UIFontDescriptor.SystemDesign = .default) {
        guard let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
            .withDesign(design) else {
            preconditionFailure("Could not find a matching font")
        }
        self.init(descriptor: descriptor, size: 0)
    }
}
