import Foundation

final class APIFetch {
    static let shared = APIFetch()

    struct Constants {
        static let toHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=pt&apiKey=1d7225c5d26242dca298f42bbea8e1b8")
        
        static let toLatestURl = URL(string: "https://newsapi.org/v2/everything?q=latest&sortBy=publishedAt&apiKey=1d7225c5d26242dca298f42bbea8e1b8")
        
    }
    
    private init() {}
    
    public func getTopNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.toHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getLatestNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.toLatestURl else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
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
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {
    let name: String
}
