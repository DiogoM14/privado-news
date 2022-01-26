import UIKit
import SafariServices
import Firebase

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var viewModels = [ArticleModel]()
    private var articles = [Article]()
    let defaults = UserDefaults.standard
    let myQueue = DispatchQueue.global()
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Launch") == false {
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcommingPage")
                present(view, animated: true, completion: nil)
            
            defaults.set(true, forKey: "First Launch")
        }
        
        title = "Home"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

        CacheController.shared.getArticlesByCache { [weak self] articles in
            self?.articles = articles
            self?.viewModels = articles.compactMap({
               ArticleModel(
                id: $0.id,
                title: $0.title,
                summary: $0.summary ?? "Sem Descrição para mostrar",
                imageURL: URL(string: $0.imageUrl ?? ""),
                newsSite: $0.newsSite ?? "Sem autor",
                publishedAt: $0.publishedAt ?? ""
               )
            })

            DispatchQueue.main.async {
               self?.tableView.reloadData()
            }
       }
        
        createSearchBar()
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    @objc func handleRefreshControl(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) {
        CacheController.shared.getArticlesByCache { [weak self] articles in
            self?.articles = articles
            self?.viewModels = articles.compactMap({
               ArticleModel(
                id: $0.id,
                title: $0.title,
                summary: $0.summary ?? "Sem Descrição para mostrar",
                imageURL: URL(string: $0.imageUrl ?? ""),
                newsSite: $0.newsSite ?? "Sem autor",
                publishedAt: $0.publishedAt ?? ""
               )
            })

            DispatchQueue.main.async {
               self?.tableView.reloadData()
            }
       }

        self.tableView.refreshControl?.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticlesTableViewCell.identifier,
            for: indexPath
        )as? ArticlesTableViewCell else {
            fatalError()
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        
        vc.article = articles[indexPath.row]
        
        vc.image = viewModels[indexPath.row].imageData
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    //Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        APIFetch.shared.search(with: text){ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    ArticleModel(
                        id: $0.id,
                        title: $0.title,
                        summary: $0.summary ?? "Sem Descrição para mostrar",
                        imageURL: URL(string: $0.imageUrl ?? ""),
                        newsSite: $0.newsSite ?? "",
                        publishedAt: $0.publishedAt ?? ""
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
