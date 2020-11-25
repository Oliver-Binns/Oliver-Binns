//
//  CodeBlock.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 11/10/2020.
//
import SwiftUI
import Sourceful

struct CodeBlock: View {
    var title: String?
    @State var code: String
    
    @State private var desiredHeight: CGFloat = 200

    var body: some View {
        VStack(alignment: .center) {
            if title != nil, !title!.isEmpty {
                Text(title!)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            SourceCodeTextView(text: $code,
                               desiredHeight: $desiredHeight,
                               customization: .init(didChangeText: { _ in },
                                                    insertionPointColor: { Sourceful.Color.white },
                                                    lexerForSource: { _ in
                                                        SwiftLexer()
                                                    },
                                                    textViewDidBeginEditing: { _ in },
                                                    theme: { () -> SourceCodeTheme in
                                                        DynamicTypeTheme()
                                                    }))
                .frame(height: desiredHeight)
        }
    }
}

struct CodeBlock_Previews: PreviewProvider {
    static var previews: some View {
        CodeBlock(code: "")
    }
}
