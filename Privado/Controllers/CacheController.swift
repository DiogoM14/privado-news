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
            NotificationController.shared.notification()
            
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
    
//    func loadImagesUsingCacheWithUrlString(urlString: String) {
//
//        self.image = nil
//
//        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = cachedImage
//            return
//
//        }
//
//        let url = URL(string: urlString)
//        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            DispatchQueue.main.async  {
//                if let downloadedImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
//
//                    self.image = downloadedImage
//
//                }
//
//            }
//
//        }).resume()
//
//    }
}


