import Foundation
import UIKit

class ArticleService {
    
    static func downloadArticle(withURL url: URL, completion: @escaping (_ article: [Article]) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadedArticle: [Article]
            
            if let data = data {
                do {
                    downloadedArticle = try JSONDecoder().decode([Article].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(downloadedArticle)
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        
        dataTask.resume()
    }
}
