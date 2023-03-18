import Foundation

struct Post: Decodable {
    let title: String
    let readingTime: Int
    let date: Date
    let imagePath: String?
    let contentPath: String
    let color: String?
}
extension Post: Identifiable {
    var id: String {
        contentPath
    }
}
