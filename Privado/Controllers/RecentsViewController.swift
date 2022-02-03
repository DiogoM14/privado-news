import UIKit
import Firebase

class RecentsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var articlesLiked: [Int] = []
    
    private var viewModels = [ArticleModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("userLikes").document(String(describing: userId!)).collection("articleId").getDocuments() { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                self.articlesLiked.append(Int(document.documentID)!)
                
                APIFetch.shared.getArticleById(with: String(describing: document.documentID)) { [weak self] articles in
                    self?.articles.append(articles)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
               }
            }
        }

        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentsTableCellView", for: indexPath) as? RecentsTableViewCell else {return UITableViewCell()}
        
        let url = URL(string: self.articles[indexPath.row].imageUrl!)
        
        
        if url != nil {
            URLSession.shared.dataTask(with: url!) { data, _, error in
                guard let data = data, error == nil else{
                    return
                }

                DispatchQueue.main.async {
                    cell.articleImage.image =  UIImage(data: data)
                }
            }.resume()
        }
        
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.publishedAtLabel.text = DateConverter.convertDateFormater(self.articles[indexPath.row].publishedAt)
        cell.source.text = self.articles[indexPath.row].newsSite
       
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("click")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        
        let url = URL(string: self.articles[indexPath.row].imageUrl!)
        
        
        if url != nil {
            URLSession.shared.dataTask(with: url!) { data, _, error in
                guard let data = data, error == nil else{
                    return
                }

                DispatchQueue.main.async {
                    vc.image = data
                }
            }.resume()
        }
        
        vc.article = self.articles[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefreshControl(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) {
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("userLikes").document(String(describing: userId!)).collection("articleId").getDocuments() { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                self.articlesLiked.append(Int(document.documentID)!)
                
                APIFetch.shared.getArticleById(with: String(describing: document.documentID)) { [weak self] articles in
                    self?.articles.append(articles)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
               }
            }
        }
        
        self.tableView.refreshControl?.endRefreshing()
    }
}
