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
        if post == nil {
            if isLoading {
                ActivityIndicator(isAnimating: .constant(true),
                                  style: .large)
            } else {
                Text("Error")
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    guard let url = activity.webpageURL,
                          !url.lastPathComponent.isEmpty else { return }
                    isLoading = true
                    let slug = url.lastPathComponent
                    loadPost(withSlug: slug)
                }
            }
        } else {
            PostView(post: post!)
        }
    }

    func loadPost(withSlug slug: String) {
        /*BlogService.getPost(slug: slug, client: .init()) { result in
            switch result {
            case .success(let post):
                self.post = post
            case .failure(let error):
                isLoading = false
                print(error)
            }
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
