//
//  Post.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import SwiftUI

final class Post: Decodable, Identifiable {
    let id: Int

    let title: String
    private(set) var excerpt: NSAttributedString?

    let link: URL?
    let imageURL: URL?

    let date: Date

    var content: [PostContent] = []

    enum CodingKeys: String, CodingKey {
        case id, link, title, excerpt
        case date = "date_gmt"
        case imageURL = "jetpack_featured_media_url"
        case content
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)

        title = try values.decode(Content.self, forKey: .title).rendered

        link = try values.decode(URL.self, forKey: .link)
        imageURL = try? values.decode(URL.self, forKey: .imageURL)

        date = try values.decode(Date.self, forKey: .date)

        let excerptHTML = try values.decode(Content.self, forKey: .excerpt).rendered
        let contentHTML = try values.decode(Content.self, forKey: .content).rendered

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

            self.content = contentHTML.components(separatedBy: "\n\n\n").map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter {
                !$0.isEmpty
            }.map {
                PostContent.mapContent(string: $0)
            }

            group.leave()
        }
    }
}
struct Content: Decodable {
    let rendered: String
}
