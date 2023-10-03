/**
 * This defines the struct used to represent an individual article in the blog.
 */
import Foundation

// we made this to handle and organize the data when talking with the database
struct Article: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var date: Date
    var body: String
}

struct ArticleCategory: Hashable, Codable, Identifiable {
    var id: String
    var articles: [Article]
}
