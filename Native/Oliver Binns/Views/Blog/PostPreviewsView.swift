//
//  PostPreviewView.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//

import SwiftUI

struct PostPreviewsView: View {
    @State var posts: [Post] = []
    @State var selectedItem: Post?

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(posts.sorted(by: { $0.date > $1.date })) { post in
                    PostHeader(post: post, contentMode: .fill)
                        .cornerRadius(16)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(radius: 16)
                        .onTapGesture {
                            selectedItem = post
                        }
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .sheet(item: $selectedItem) { post in
                PostView(post: post, canBeDismissed: true)
            }
        }
        .navigationBarTitle("Blog")
        .task {
            guard posts.isEmpty else { return }
            await loadPosts()
        }
    }

    private func loadPosts() async {
        do {
            self.posts = try await BlogService.getPosts(client: .init())
        } catch {
            print("error", error)
            // handle error
        }
    }
}
struct PostPreviewsView_Previews: PreviewProvider {
    static var previews: some View {
        PostPreviewsView()
    }
}
