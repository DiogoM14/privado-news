import Foundation

final class APIFetch {
    static let shared = APIFetch()

    struct Constants {
        static let toHeadlinesURL = URL(string: "https://api.spaceflightnewsapi.net/v3/articles")
        
        static let issDiary = URL(string: "https://api.spaceflightnewsapi.net/v3/reports")
        
        static let issDiarySearch = URL(string: "https://api.spaceflightnewsapi.net/v3/reports?summary_contains=")
        
        static let searchUrlString = "https://api.spaceflightnewsapi.net/v3/articles?summary_contains="
        
        static let articleById = "https://api.spaceflightnewsapi.net/v3/articles/"
    }
    
    private init() {}
    
    public func getTopNews(completion: @escaping (_ article: [Article]) -> ()) {
        
        guard let url = Constants.toHeadlinesURL else {
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
}

// Modules
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
