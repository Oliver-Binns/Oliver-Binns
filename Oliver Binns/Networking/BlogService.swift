//
//  BlogService.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//

import Foundation

struct BlogService {
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

    static func getPost(id: String,
                        client: NetworkClient,
                        completion: @escaping (Result<Post, Error>) -> Void) {
        //client.executeRequest(request: .posts, completion: <#T##(Result<Data, Error>) -> Void#>)
    }
}
