//
//  PostView.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 10/10/2020.
//
import SwiftUI

struct PostView: View {
    let post: Post
    @State private var postContent: [PostContent] = []

    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        PostHeader(post: post)

                        if postContent.isEmpty {
                            HStack {
                                Spacer()
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                Spacer()
                            }
                        }

                        VStack(spacing: 8) {
                            ForEach(0..<postContent.count, id: \.self) { index in
                                viewForContent(postContent[index])
                            }
                        }.padding(proxy.safeAreaInsets)
                    }
                }
                .navigationBarItems(trailing: ShareButton(activityItems: [URL.web(forPost: post)]) {
                    Image(systemName: "square.and.arrow.up")
                })
                .task {
                    await loadPost()
                }.ignoresSafeArea(.container, edges: .horizontal)

                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .shadow(radius: 8)
                        .font(.largeTitle)
                }.padding()
            }
        }
    }

    private func loadPost() async {
        do {
            self.postContent = try await BlogService
                .getPost(path: post.contentPath, client: .init())
        } catch {
            // todo: handle error
            print("error occurred \(error)")
        }
    }

    func font(for level: Int) -> Font {
        switch level {
        case 1: return .largeTitle
        case 2: return .title
        case 3: return .title2
        case 4: return .title3
        case 5: return .headline
        default: return .subheadline
        }
    }

    @ViewBuilder
    func viewForContent(_ content: PostContent) -> some View {
        switch content {
        case .heading(let string, let level):
            Text(string)
                .font(font(for: level))
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
                .readableGuidePadding()
        case .body(let string):
            Text(string)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                .readableGuidePadding()
        case .code(let content):
            CodeSnippet(code: content)
        case .slider(let caption, let firstImage, let secondImage):
            Slider(caption: caption, firstImage: firstImage, secondImage: secondImage)
        case .image(let caption, let altText, let url):
            Figure(caption: caption, altText: altText, url: url)
        case .youTube(let videoID, let caption):
            VStack(alignment: .center, spacing: 4) {
                YouTubePlayer(videoID: videoID)
                    .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                if let caption {
                    Text(caption)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }.readableGuidePadding()
        case .link(let imageURL, let title, let body, let url):
            LinkView(imageURL: imageURL,
                     title: title, bodyText: body,
                     url: url)
            .readableGuidePadding()
        case .unorderedList(let content):
            AnyView(unorderedList(content: content))
                .readableGuidePadding()
        case .orderedList(let content):
            AnyView(orderedList(content: content))
                .readableGuidePadding()
        case .blank:
            EmptyView()
        case .column(let columns):
            HStack(alignment: .top) {
                ForEach(0..<columns.count, id: \.self) { index in
                    AnyView(viewForContent(columns[index]))
                }
            }
        case .horizontalRule:
            Divider()
                .frame(height:20)
                .overlay(Color.accentColor)
        default:
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text("Could not render this content.").italic()
            }
        }
    }

    @ViewBuilder
    func unorderedList(content: [PostContent]) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<content.count, id: \.self) { index in
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    if case .body = content[index] {
                        Text("•")
                    } else {
                        Text(" ")
                    }
                    viewForContent(content[index])
                }
            }
        }
    }

    @ViewBuilder
    func orderedList(content: [PostContent]) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<content.count, id: \.self) { index in
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(index+1).")
                    viewForContent(content[index])
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
