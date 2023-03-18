import Markdown
import Foundation

struct MarkdownParser {
    enum Error: Swift.Error {
        case invalidMetadata
    }

    func parse(_ markdown: String) throws -> [PostContent] {
        [.horizontalRule] + Document(parsing: markdown)
            .children.dropFirst(2) // remove first two as they are used for metadata
            .flatMap(parseRecursively)
    }

    private func parseRecursively(child: Markup) -> [PostContent] {
        switch child {
        case let heading as Heading:
            return parse(heading)
        case is ThematicBreak:
            return [.horizontalRule]
        case let paragraph as Paragraph:
            return parse(paragraph)
        case let text as Text:
            return [.body(AttributedString(text.string))]
        case let quote as BlockQuote:
            return parse(quote)
        case let block as CodeBlock:
            return [.code(block.code.trimmingCharacters(in: .whitespacesAndNewlines))]
        default:
            print("missed", child.debugDescription())
            return []
        }
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
        let string = AttributedString(try: paragraph.format())
        return [.body(string)]
    }

    private func parse(_ quote: BlockQuote) -> [PostContent] {
        guard let child = quote.child(at: 0) else {
            assertionFailure("Expected quote to have at least one child")
            return []
        }

        switch child.format() {
        case let value where value.hasPrefix("> prettylink"):
            return parsePrettyLink(quote)
        case let value where value.hasPrefix("> youtube"):
            return parseYouTube(quote)
        default:
            return [.body(AttributedString(try: quote.format()))]
        }
    }

    private func parseYouTube(_ youtube: BlockQuote) -> [PostContent] {
        guard let link = youtube.findText(withPrefix: "youtube "),
              let components = URLComponents(string: link),
              let videoID = components.queryItems?.first(where: { $0.name == "v" })?.value else {
            assertionFailure("Invalid YouTube embed: \(youtube.debugDescription())")
            return []
        }
        return [.youTube(videoID, nil)]
    }

    private func parsePrettyLink(_ link: BlockQuote) -> [PostContent] {
        guard let title = link.findText(withPrefix: "title "),
              let description = link.findText(withPrefix: "description "),
              let urlString = link.findText(withPrefix: "prettylink ") else {
            assertionFailure("Invalid pretty link: \(link.debugDescription())")
            return []
        }

        let url = urlString.isValidURL ? URL(string: urlString)! : .web(forPath: urlString)

        if let image = link.findText(withPrefix: "image ") {
            guard image.isValidURL,
                  let imageURL = URL(string: image) else {
                return [.link(.image(path: image), title, description, url)]
            }
            return [.link(imageURL, title, description, url)]
        }
        return [.link(nil, title, description, url)]
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
