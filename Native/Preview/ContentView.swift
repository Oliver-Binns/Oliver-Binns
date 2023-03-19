//
//  ContentView.swift
//  Preview
//
//  Created by Oliver Binns on 28/10/2020.
//

import SwiftUI

struct ContentView: View {
    @State var post: Post?
    @State var isLoading: Bool = false

    var body: some View {
        if let post {
            PostView(post: post, canBeDismissed: false)
        } else {
            if isLoading {
                ActivityIndicator(isAnimating: .constant(true),
                                  style: .large)
            } else {
                Text("Error")
                    .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                        guard let url = activity.webpageURL else { return }
                        isLoading = true
                        let postID = url.lastPathComponent
                        Task { await loadPost(postID) }
                    }
            }
        }
    }

    func loadPost(_ id: String) async {
        do {
            self.post = try await BlogService.getPosts(client: .init()).first(where: {
                $0.id.hasSuffix(id)
            })
        } catch {
            // TODO: handle error
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
