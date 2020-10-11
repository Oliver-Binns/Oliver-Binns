//
//  PostView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//
import SwiftUI

struct PostView: View {
    @State var post: Post

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                PostHeader(post: post)
                ForEach(0..<post.content.count, id: \.self) { index in
                    switch post.content[index] {
                    case .heading1(let string):
                        Text(string).font(.title)
                    case .heading2(let string):
                        Text(string).font(.title2)
                    case .heading3(let string):
                        Text(string).font(.title3)
                    case .body(let string):
                        AttributedText(attributedText: string)
                            .font(.system(size: 17, weight: .regular, design: .serif))
                    case .code(let string):
                        CodeBlock(string)
                    case .twitter:
                        TwitterView()
                    case .link(let string):
                        LinkView(htmlString: string)
                    case .horizontalRule:
                        Divider()
                    default:
                        Text("Could not render this content.").italic()
                    }
                }
            }.padding()
        }.navigationTitle("")

    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
