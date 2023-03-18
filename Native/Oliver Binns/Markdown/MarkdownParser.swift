import Markdown
import Foundation

struct MarkdownParser {
    enum Error: Swift.Error {
        case invalidMetadata
    }

    func parse(_ markdown: String) throws -> [PostContent] {
        let children = Array(Document(parsing: markdown).children)
        var index = 2 // remove first two elements as they are used for metadata
        var postContent: [PostContent] = []

        while index < children.count {
            defer { index += 1 }

            let child = children[index]

            switch child {
            case let heading as Heading:
                postContent.append(contentsOf: parse(heading))
            case is ThematicBreak:
                postContent.append(.horizontalRule)
            case let paragraph as Paragraph:
                postContent.append(contentsOf: parse(paragraph))
            case let text as Text:
                postContent.append(.body(AttributedString(text.string)))
            case let quote as BlockQuote:
                if let content = parse(quote) {
                    postContent.append(content)
                }
            case let block as CodeBlock:
                postContent.append(.code(block.code.trimmingCharacters(in: .whitespacesAndNewlines)))
            default:
                print("missed", child.debugDescription())
                postContent.append(.cannotRender)
            }
        }

        return postContent
    }

    private func parse(_ heading: Heading) -> [PostContent] {
        heading.children
            .compactMap { $0 as? Text }
            .map { AttributedString(try: $0.string) }
            .map { text in
                PostContent.heading(text, heading.level)
            }
    }

    private func parse(_ paragraph: Paragraph) -> [PostContent] {
        var children: [InlineMarkup] = []
        var content: [PostContent] = []

        let update = {
            guard !children.isEmpty else { return }
            let string = AttributedString(try: Paragraph(children).format())
            content.append(.body(string))
        }

        var index: Int = 0

        while index < paragraph.childCount {
            defer { index += 1 }

            let child = paragraph.child(at: index)!

            switch child {
            case let image as Image:
                update() // resolve precursor text

                guard let imagePath = image.source,
                      let altText = image.child(at: 0) as? Text else { break }

                let imageURL = imagePath.isValidURL ?
                    URL(string: imagePath)! : .image(path: imagePath)

                // find caption (next node)
                index += 2
                let caption = paragraph.child(at: index) as? Emphasis

                content.append(.image(caption.map { AttributedString(try: $0.format()) },
                                      altText.string,
                                      imageURL))
            case let markup as InlineMarkup:
                children.append(markup)
            default:
                assertionFailure("Non-inline mark-up shouldn't be a child of paragraph")
            }
        }

        update()

        return content
    }

    private func parse(_ quote: BlockQuote) -> PostContent? {
        guard let child = quote.child(at: 0) else {
            assertionFailure("Expected quote to have at least one child")
            return nil
        }

        switch child.format() {
        case let value where value.hasPrefix("> prettylink"):
            return parsePrettyLink(quote)
        case let value where value.hasPrefix("> youtube"):
            return parseYouTube(quote)
        default:
            return .body(AttributedString(try: quote.format()))
        }
    }

    private func parseYouTube(_ youtube: BlockQuote) -> PostContent? {
        guard let link = youtube.findText(withPrefix: "youtube "),
              let components = URLComponents(string: link),
              let videoID = components.queryItems?.first(where: { $0.name == "v" })?.value else {
            assertionFailure("Invalid YouTube embed: \(youtube.debugDescription())")
            return nil
        }
        return .youTube(videoID, nil)
    }

    private func parsePrettyLink(_ link: BlockQuote) -> PostContent? {
        guard let title = link.findText(withPrefix: "title "),
              let description = link.findText(withPrefix: "description "),
              let urlString = link.findText(withPrefix: "prettylink ") else {
            assertionFailure("Invalid pretty link: \(link.debugDescription())")
            return nil
        }

        let url = urlString.isValidURL ? URL(string: urlString)! : .web(forPath: urlString)

        if let image = link.findText(withPrefix: "image ") {
            guard image.isValidURL,
                  let imageURL = URL(string: image) else {
                return .link(.image(path: image), title, description, url)
            }
            return .link(imageURL, title, description, url)
        }
        return .link(nil, title, description, url)
    }
}

extension AttributedString {
    init(try markdown: String) {
        do {
            try self.init(markdown: markdown)
        } catch {
            self.init(markdown)
        }
    }
}


extension Markup {
    func findText(withPrefix prefix: String) -> String? {
        findTextNode(withPrefix: prefix)?.string.removePrefix(prefix)
    }

    func findTextNode(withPrefix prefix: String) -> Text? {
        for child in children {
            if let child = child as? Text,
                child.string.hasPrefix(prefix) {
                return child
            } else if let child = child.findTextNode(withPrefix: prefix) {
                return child
            }
        }
        return nil
    }
}
