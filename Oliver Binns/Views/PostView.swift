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
                    viewForContent(post.content[index])
                }
            }.readableGuidePadding()
        }.navigationTitle("")
    }

    @ViewBuilder
    func viewForContent(_ content: PostContent) -> some View {
        switch content {
        case .heading1(let string):
            Text(string).font(.title)
        case .heading2(let string):
            Text(string).font(.title2)
        case .heading3(let string):
            Text(string).font(.title3)
        case .body(let string):
            AttributedText(attributedText: string)
                .font(.system(size: 17, weight: .regular, design: .serif))
        case .code(let title, let content):
            CodeBlock(title: title, code: content)
        case .figure(let caption, let url):
            Figure(caption: caption, url: url)
        case .twitter:
            TwitterView()
        case .link(let imageURL, let title, let body, let url):
            LinkView(imageURL: imageURL,
                     title: title, bodyText: body,
                     url: url)
        case .column(let columns):
            HStack(alignment: .top) {
                ForEach(0..<columns.count, id: \.self) { index in
                    AnyView(viewForContent(columns[index]))
                }
            }
        case .horizontalRule:
            Divider()
        default:
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text("Could not render this content.").italic()
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
