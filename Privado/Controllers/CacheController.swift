import Foundation

class CacheController {
    let cache = NSCache<NSString, NSArray>()
    static let shared = CacheController()

//    print(cache.object)

    func setArticlesToCache() {
        APIFetch.shared.getTopNews { [weak self] articles in
            self?.cache.setObject(articles as NSArray, forKey: "Articles")
           
           DispatchQueue.main.async {
               print("VIM DO SET")
               print(self?.cache.object(forKey: "Articles") as Any)
           }
       }

    }

    func getArticlesByCache() {
        if self.cache.object(forKey: "Articles") == nil {
            self.setArticlesToCache()
        } else {
            print("VIM DO GET")
            print(self.cache.object(forKey: "Articles") as Any)
        }
    }
}


