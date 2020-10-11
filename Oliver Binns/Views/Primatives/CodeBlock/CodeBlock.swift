//
//  CodeBlock.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 11/10/2020.
//
import SwiftUI

struct CodeBlock: View {
    var title: String?
    @State var code: String
    
    @State private var desiredHeight: CGFloat = 200

    var body: some View {
        VStack {
            if title != nil {
                Text(title!).font(.headline)
            }
            SourceCodeTextView(text: $code, desiredHeight: $desiredHeight)
                .frame(height: desiredHeight)
        }
    }
}

struct CodeBlock_Previews: PreviewProvider {
    static var previews: some View {
        CodeBlock(code: "")
    }
}
