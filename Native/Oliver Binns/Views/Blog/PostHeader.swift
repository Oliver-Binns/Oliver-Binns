//
//  PostHeader.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//

import SwiftUI

struct PostHeader: View {
    @State var post: Post
    var contentMode: ContentMode = .fit

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if post.imageURL != nil {
                AsyncImage(
                    url: post.imageURL!,
                    placeholder: {
                        Image("Placeholder").resizable()
                    },
                    image: { Image(uiImage: $0).resizable() }
                )
                .aspectRatio(contentMode: contentMode)
            }
            Text(post.title)
                .font(.title)
            Text("Posted on \(DateFormatter.humanReadable.string(from: post.publishedDate))")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct PostHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
