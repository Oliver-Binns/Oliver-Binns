//
//  PostPreviewView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//

import SwiftUI

struct PostPreviewsView: View {
    @State var posts: [Post] = []
    @State var selectedItem: Int?
    @State private var desiredHeight: [CGFloat] = []

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        ScrollView(.vertical) {
            ForEach(posts, id: \.self) { post in
                NavigationLink(destination: PostView(post: post),
                               tag: post.id, selection: $selectedItem) {
                    VStack(alignment: .leading, spacing: 8) {
                        PostHeader(post: post, contentMode: .fill)
                        AttributedText(attributedText: post.excerpt)
                            .font(.system(size: 17, weight: .regular, design: .serif))
                    }
                    .padding()
                }.buttonStyle(PlainButtonStyle())
                Divider()
            }
        }
        .navigationBarTitle("Blog")
        .onAppear {
            guard posts.isEmpty else { return }
            BlogService.getPosts(client: .init()) { result in
                _ = result.map { posts in
                    self.desiredHeight = posts.map { _ in 0 }
                    if horizontalSizeClass == .regular && selectedItem == nil {
                        self.selectedItem = posts.first?.id
                    }
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
