import Foundation

class CacheController {
    let cache = NSCache<NSString, NSArray>()
    static let shared = CacheController()
    private var articles = [Article]()

    func setArticlesToCache(completion: @escaping (_ article: [Article]) -> ()) {
        APIFetch.shared.getTopNews { [weak self] articles in
            self?.articles = articles
            self?.cache.setObject(articles as NSArray, forKey: "Articles")
           
           DispatchQueue.main.async {
//               print("VIM DO SET")
               completion(self?.cache.object(forKey: "Articles") as! [Article])
           }
       }
    }

    func getArticlesByCache(completion: @escaping (_ article: [Article]) -> ()) {
        if self.cache.object(forKey: "Articles") == nil {
            self.setArticlesToCache { article in
                completion(article)
            }
        } else {
//            print("VIM DO GET")
            let cachedArticles = self.cache.object(forKey: "Articles") as! [Article]
            completion(self.cache.object(forKey: "Articles") as! [Article])
            
            self.setArticlesToCache { article in
                if article[0].id > cachedArticles[0].id {
//                    print("VIM DO GET < CACHE")
                    completion(article)
                }
            }
        }
    }
}


