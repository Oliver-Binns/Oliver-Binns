import Foundation

struct BlogService {
    enum BlogError: Error {
        case notFound
    }

    static func getPosts(client: NetworkClient) async throws -> [Post] {
        let data = try await client.executeRequest(url: .posts)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Post].self, from: data)
    }

    static func getPost(path: String, client: NetworkClient) async throws -> [PostContent] {
        let data = try await client.executeRequest(url: .post(atPath: path))
        guard let markdown = String(data: data, encoding: .utf8) else {
            throw BlogError.notFound
        }
        return try MarkdownParser().parse(markdown)
    }
}
