//
//  PostPreviewView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//

import SwiftUI

struct PostPreviewsView: View {
    @State var posts: [Post] = []
    @State private var desiredHeight: [CGFloat] = []

    var body: some View {
        List(0..<posts.count, id: \.self) { index in
            ZStack {
                VStack(alignment: .leading, spacing: 8) {
                    PostHeader(post: posts[index])
                    AttributedText(attributedText: posts[index].excerpt)
                        .font(.system(size: 17, weight: .regular, design: .serif))
                }
                NavigationLink(destination: PostView(post: posts[index])) {
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitle("Blog")
        .onAppear {
            BlogService.getPosts(client: .init()) { result in
                _ = result.map { posts in
                    self.desiredHeight = posts.map { _ in 0 }
                    self.posts = posts
                }
            }
        }
    }
}
struct PostPreviewsView_Previews: PreviewProvider {
    static var previews: some View {
        PostPreviewsView()
    }
}
