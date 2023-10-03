/**
 * BareBonesBlogArticle is the article service—it completely hides the data store from the rest of the app.
 * No other part of the app knows how the data is stored. If anyone wants to read or write data, they have
 * to go through this service.
 */
import Foundation

import Firebase

// centralizing certain values
let COLLECTION_NAME = "articles"
let PAGE_LIMIT = 20

// making an enum for our possible errors we might run into
// allows our views to communicate what is going wrong
enum ArticleServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

// modelling the connection to FireStore Database
// since this "traffics" articles, we made a struct for them
class KastenSpellsBlogArticle: ObservableObject {
    // the libraries that the databases provide give you access to
    // a "bridge" that allows you to handle and talk to the database
    
    private let db = Firestore.firestore()

    // Some of the iOS Firebase library’s methods are currently a little…odd.
    // They execute synchronously to return an initial result, but will then
    // attempt to write to the database across the network asynchronously but
    // not in a way that can be checked via try async/await. Instead, a
    // callback function is invoked containing an error _if it happened_.
    // They are almost like functions that return two results, one synchronously
    // and another asynchronously.
    //
    // To deal with this, we have a published variable called `error` which gets
    // set if a callback function comes back with an error. SwiftUI views can
    // access this error and it will update if things change.
    @Published var error: Error?

    // this makes articles!
    // this is NOT asynchronous because
    func createArticle(article: Article) -> String {
        // firebase wants a reference when creating things
        var ref: DocumentReference? = nil

        // addDocument is one of those “odd” methods.
        // starts same as query, but you are making a dictionary from the properties of
        // the Article object here
        ref = db.collection(COLLECTION_NAME).addDocument(data: [
            //"userid": whatever stores the user id
            "title": article.title,
            "date": article.date, // This gets converted into a Firestore Timestamp.
            "body": article.body
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }

        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref?.documentID ?? ""
    }

    // Note: This is quite unsophisticated! It only gets the first PAGE_LIMIT articles.
    // In a real app, you implement pagination.
    func fetchArticles() async throws -> [Article] {
        // talking to the db and telling it what collection you are working with
        let articleQuery = db.collection(COLLECTION_NAME)
            //.whereField("title", isGreaterThanOrEqualTo: "S")
            // you MUST be specific about the ORDER and the LIMIT of the data
            //.order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)

        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await articleQuery.getDocuments()
        print(querySnapshot)
        return try querySnapshot.documents.map {
            // This is likely new Swift for you: type conversion is conditional, so they
            // must be guarded in case they fail.
            guard let title = $0.get("title") as? String,

                // Firestore returns Swift Dates as its own Timestamp data type.
                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String else {
//                print("we reached article error?")
                throw ArticleServiceError.mismatchedDocumentError
            }

            
            var result = Article(
                id: $0.documentID,
                title: title,
                date: dateAsTimestamp.dateValue(),
                body: body
            )
            
            // For the hypothetical "downvotes" property, need to unpack whether this is
            // in the data or not (because this data is like JSON!!!)
//            if let downvotes = $0.get("downvotes") as? Int {
//                result.downvotes = downvotes
//            }
            print(result)
            return result
        }
    }
    
    func deleteArticle(article: Article) {
        db.collection(COLLECTION_NAME).document(article.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func editArticle(article: Article, newTitle: String, newBody: String) {
        let ref = db.collection(COLLECTION_NAME).document(article.id)

        
        // Set the "capital" field of the city 'DC'
        ref.updateData([
            "title": newTitle,
            "body": newBody
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
