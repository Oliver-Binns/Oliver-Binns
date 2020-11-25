//
//  Post.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import SwiftSoup
import SwiftUI

final class Post: NSObject, Decodable, Identifiable {
    let id: Int
    let slug: String

    let title: String
    private(set) var excerpt: NSAttributedString?

    let link: URL
    let imageURL: URL?

    let publishedDate: Date

    var content: [PostContent] = []

    enum CodingKeys: String, CodingKey {
        case id, slug, link, title, excerpt, content
        case publishedDate = "date_gmt"
        case imageURL = "jetpack_featured_media_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        slug = try values.decode(String.self, forKey: .slug)

        title = try values.decode(RenderedContent.self, forKey: .title).rendered

        link = try values.decode(URL.self, forKey: .link)
        imageURL = try? values.decode(URL.self, forKey: .imageURL)

        publishedDate = try values.decode(Date.self, forKey: .publishedDate)

        let excerptHTML = try values.decode(RenderedContent.self, forKey: .excerpt).rendered
        let contentHTML = try values.decode(RenderedContent.self, forKey: .content).rendered
        super.init()

        guard let queue = decoder.userInfo[.dispatchQueue] as? DispatchQueue,
              let group = decoder.userInfo[.dispatchGroup] as? DispatchGroup else {
            assertionFailure("Dispatch Group and Queue should be given")
            return
        }
        queue.async {
            group.wait()
            group.enter()

            self.excerpt = try? NSMutableAttributedString(data: Data(excerptHTML.utf8),
                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                          documentAttributes: nil)

            let xml = try? SwiftSoup.parse(contentHTML)
            self.content = xml?.body()?.children().compactMap {
                try? PostContent(element: $0)
            } ?? []

            group.leave()
        }
    }
}
struct RenderedContent: Decodable {
    let rendered: String
}
