//
//  SourceCodeTextEditor.swift
//
//  Created by Andrew Eades on 14/08/2020.
//

import Foundation
import Sourceful

#if canImport(SwiftUI)

import SwiftUI

#if os(macOS)

public typealias _ViewRepresentable = NSViewRepresentable

#endif

#if os(iOS)

public typealias _ViewRepresentable = UIViewRepresentable

#endif


public struct SourceCodeTextView: _ViewRepresentable {

    public struct Customization {
        var didChangeText: (SourceCodeTextView) -> Void
        var insertionPointColor: () -> Sourceful.Color
        var lexerForSource: (String) -> Lexer
        var textViewDidBeginEditing: (SourceCodeTextView) -> Void
        var theme: () -> SourceCodeTheme

        /// Creates a **Customization** to pass into the *init()* of a **SourceCodeTextEditor**.
        ///
        /// - Parameters:
        ///     - didChangeText: A SyntaxTextView delegate action.
        ///     - lexerForSource: The lexer to use (default: SwiftLexer()).
        ///     - insertionPointColor: To customize color of insertion point caret (default: .white).
        ///     - textViewDidBeginEditing: A SyntaxTextView delegate action.
        ///     - theme: Custom theme (default: DefaultSourceCodeTheme()).
        public init(
            didChangeText: @escaping (SourceCodeTextView) -> Void,
            insertionPointColor: @escaping () -> Sourceful.Color,
            lexerForSource: @escaping (String) -> Lexer,
            textViewDidBeginEditing: @escaping (SourceCodeTextView) -> Void,
            theme: @escaping () -> SourceCodeTheme
        ) {
            self.didChangeText = didChangeText
            self.insertionPointColor = insertionPointColor
            self.lexerForSource = lexerForSource
            self.textViewDidBeginEditing = textViewDidBeginEditing
            self.theme = theme
        }
    }

    @Binding private var text: String
    @Binding var desiredHeight: CGFloat

    private var custom: Customization

    public init(
        text: Binding<String>,
        desiredHeight: Binding<CGFloat>,
        customization: Customization = Customization(
            didChangeText: {_ in },
            insertionPointColor: { Sourceful.Color.white },
            lexerForSource: { _ in SwiftLexer() },
            textViewDidBeginEditing: { _ in },
            theme: { DefaultSourceCodeTheme() }
        )
    ) {
        self._text = text
        self._desiredHeight = desiredHeight
        self.custom = customization
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    #if os(iOS)
    public func makeUIView(context: Context) -> SyntaxTextView {
        let wrappedView = SyntaxTextView()
        wrappedView.isUserInteractionEnabled = false
        wrappedView.delegate = context.coordinator
        wrappedView.theme = custom.theme()
//        wrappedView.contentTextView.insertionPointColor = custom.insertionPointColor()

        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text

        return wrappedView
    }

    public func updateUIView(_ view: SyntaxTextView, context: Context) {
        DispatchQueue.main.async {
            self.desiredHeight = view.contentTextView.contentSize.height
        }
    }
    #endif

    #if os(macOS)
    public func makeNSView(context: Context) -> SyntaxTextView {
        let wrappedView = SyntaxTextView()
        wrappedView.delegate = context.coordinator
        wrappedView.theme = custom.theme()
        wrappedView.contentTextView.insertionPointColor = custom.insertionPointColor()

        context.coordinator.wrappedView = wrappedView
        context.coordinator.wrappedView.text = text

        return wrappedView
    }

    public func updateNSView(_ view: SyntaxTextView, context: Context) {
    }
    #endif


}

extension SourceCodeTextView {

    public class Coordinator: SyntaxTextViewDelegate {
        let parent: SourceCodeTextView
        var wrappedView: SyntaxTextView!

        init(_ parent: SourceCodeTextView) {
            self.parent = parent
        }

        public func lexerForSource(_ source: String) -> Lexer {
            parent.custom.lexerForSource(source)
        }

        public func didChangeText(_ syntaxTextView: SyntaxTextView) {
            DispatchQueue.main.async {
                self.parent.text = syntaxTextView.text
            }

            // allow the client to decide on thread
            parent.custom.didChangeText(parent)
        }

        public func textViewDidBeginEditing(_ syntaxTextView: SyntaxTextView) {
            parent.custom.textViewDidBeginEditing(parent)
        }
    }
}

#endif
