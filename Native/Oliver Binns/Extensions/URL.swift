import Foundation

extension URL {
    init(staticString: StaticString) {
        guard let url = URL (string: "\(staticString)") else {
            preconditionFailure ("Invalid static URL string: \(staticString) ")
        }
        self = url
    }

    static let baseURL = URL(staticString: "http://localhost/")
    static var apiURL: URL {
        baseURL.appendingPathComponent("api")
    }

    static let businessCard = URL(staticString: "https://www.oliverbinns.co.uk/businesscard.pkpass")
    static let twitter = URL(staticString: "https://www.twitter.com/oliver_binns")
    static let linkedIn = URL(staticString: "https://www.linkedin.com/in/obinns")
    static let gitHub = URL(staticString: "https://github.com/Oliver-Binns")

    static var profileImage: URL {
        image(path: "images/profile-yellow.jpg")
    }

    static var posts: URL {
        apiURL
            .appendingPathComponent("posts.json")
    }

    static func post(atPath path: String) -> URL {
        apiURL
            .appendingPathComponent("\(path).md")
    }

    static func image(path: String) -> URL {
        baseURL
            .appendingPathComponent(path)
    }

    static func web(forPath path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }

    static func web(forPost post: Post) -> URL {
        baseURL.appendingPathComponent(post.contentPath)
    }
}
