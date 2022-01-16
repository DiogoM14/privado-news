import Foundation

class ArticlesTableViewCellViewModel {
    let id: Int
    let title : String
    let summary : String
    let imageURL : URL?
    var imageData: Data? = nil
    var newsSite: String?
    var publishedAt: String
    
    init(
        id: Int,
        title : String,
        summary : String,
        imageURL : URL?,
        newsSite : String,
        publishedAt : String
    ){
        self.id = id
        self.title = title
        self.summary = summary
        self.imageURL = imageURL
        self.newsSite = newsSite
        self.publishedAt = publishedAt
    }
}
