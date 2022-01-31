import Foundation

class CommentModel {
    let comment: String
    let username: String
    let timestamp: String
    
    init(
        comment: String,
        username: String,
        timestamp: String
    ){
        self.comment = comment
        self.username = username
        self.timestamp = timestamp
    }
}
