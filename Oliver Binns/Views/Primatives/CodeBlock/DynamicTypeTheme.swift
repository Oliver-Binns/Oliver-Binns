//
//  DynamicTypeTheme.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 18/10/2020.
//
import Sourceful
import UIKit

public struct DynamicTypeTheme: SourceCodeTheme {
    public init() {

    }

    private static var lineNumbersColor: Color {
        return Color(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    }

    public let lineNumbersStyle: LineNumbersStyle? = {
        let fontSize = Font.preferredFont(forTextStyle: .callout).pointSize
        let lineNumberFont = Font(name: "Menlo", size: fontSize)!
        return LineNumbersStyle(font: lineNumberFont, textColor: lineNumbersColor)
    }()

    public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color(red: 21/255.0, green: 22/255, blue: 31/255, alpha: 1.0), minimumWidth: 32)

    public let font: Font = {
        let fontSize = Font.preferredFont(forTextStyle: .subheadline).pointSize
        return Font(name: "Menlo", size: fontSize)!
    }()


    public let backgroundColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)

    public func color(for syntaxColorType: SourceCodeTokenType) -> Color {

        switch syntaxColorType {
        case .plain:
            return .white

        case .number:
            return Color(red: 116/255, green: 109/255, blue: 176/255, alpha: 1.0)

        case .string:
            return Color(red: 211/255, green: 35/255, blue: 46/255, alpha: 1.0)

        case .identifier:
            return Color(red: 20/255, green: 156/255, blue: 146/255, alpha: 1.0)

        case .keyword:
            return Color(red: 215/255, green: 0, blue: 143/255, alpha: 1.0)

        case .comment:
            return Color(red: 69.0/255.0, green: 187.0/255.0, blue: 62.0/255.0, alpha: 1.0)

        case .editorPlaceholder:
            return backgroundColor
        }

    }

}
