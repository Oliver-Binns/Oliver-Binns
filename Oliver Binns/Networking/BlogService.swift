//
//  BlogService.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import Foundation

struct BlogService {
    enum BlogError: Error {
        case notFound
    }

    static func getPosts(client: NetworkClient,
                         completion: @escaping (Result<[Post], Error>) -> Void) {
        client.executeRequest(request: .posts) {
            switch $0 {
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

    static func getPost(slug: String,
                        client: NetworkClient,
                        completion: @escaping (Result<Post, Error>) -> Void) {
        getPosts(client: client) {
            completion($0.flatMap { success in
                guard let post = success.first(where: { $0.slug == slug }) else {
                    return .failure(BlogError.notFound)
                }
                return .success(post)
            })
        }
    }
}
