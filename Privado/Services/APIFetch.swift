import Foundation

final class APIFetch {
    static let shared = APIFetch()  // Used to become those next functions accessible throughout the app

    struct Constants {
        static let toHeadlinesURL = URL(string: "https://api.spaceflightnewsapi.net/v3/articles")
        
        static let issDiary = URL(string: "https://api.spaceflightnewsapi.net/v3/reports")
        
        static let issDiarySearch = URL(string: "https://api.spaceflightnewsapi.net/v3/reports?summary_contains=")
        
        static let searchUrlString = "https://api.spaceflightnewsapi.net/v3/articles?summary_contains="
        
        static let articleById = "https://api.spaceflightnewsapi.net/v3/articles/"
    }
    
    private init() {}
    
    public func getTopNews(completion: @escaping (_ article: [Article]) -> ()) {    // Fetch of Home page's articles and return an Article as callback
        
        guard let url = Constants.toHeadlinesURL else { // Get api url from the var
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in    // Task thats fetching the url -> data is the response
            if let data = data {    // If data exists
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)   // Converts to JSON
                    
                    DispatchQueue.main.async {  //  Aysnc response with the main thread
                        completion(result)  // Completion is a promise
                    }
                }
                catch {
                    print("Error fetching data from API (top news)")
                }
            }
        }
        task.resume()
    }
    
    public func getIssDiary(completion: @escaping (_ article: [Article]) -> ()) {
        
        guard let url = Constants.issDiary else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                catch {
                    print("Error fetching data from API (top news)")
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func searchIssDiary(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getArticleById(with id: String, completion: @escaping (_ article: Article) -> ()) {
        guard !id.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.articleById + id
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in    // Task thats fetching the url -> data is the response
            if let data = data {    // If data exists
                do {
                    let result = try JSONDecoder().decode(Article.self, from: data)   // Converts to JSON
                    
                    DispatchQueue.main.async {  //  Aysnc response with the main thread
                        completion(result)  // Completion is a promise
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

// Models
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let id: Int
    let title: String
    let url: String?
    let imageUrl: String?
    let newsSite: String?
    let summary: String?
    let publishedAt: String?
}
