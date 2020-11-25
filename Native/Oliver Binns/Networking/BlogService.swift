//
//  BlogService.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import Foundation

struct BlogService {
    enum BlogError: Error {
        case notFound
    }

    static func getPosts(client: NetworkClient,
                         completion: @escaping (Result<[Post], Error>) -> Void) {
        client.executeRequest(request: .posts) {
            decodeList(result: $0, completion: completion)
        }
    }

    static func getPost(slug: String,
                        client: NetworkClient,
                        completion: @escaping (Result<Post, Error>) -> Void) {
        client.executeRequest(request: .post(withSlug: slug)) { result in
            decodeList(result: result) {
                completion($0.flatMap { posts in
                    guard let post = posts.first else {
                        return .failure(BlogError.notFound)
                    }
                    return .success(post)
                })
            }
        }
    }

    private static func decodeList(result: Result<Data, Error>,
                                   completion: @escaping (Result<[Post], Error>) -> Void) {
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder(dateFormatter: .jsonDecoder)
                let queue = DispatchQueue(label: "htmlQueue")
                let group = DispatchGroup()

                decoder.userInfo[.dispatchGroup] = group
                decoder.userInfo[.dispatchQueue] = queue

                let decoded = try decoder.decode([Post].self, from: data)

                queue.async {
                    group.wait()
                    group.enter()
                    completion(.success(decoded))
                }
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
