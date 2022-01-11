import UIKit
import SafariServices

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var viewModels = [ArticlesTableViewCellViewModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Privado"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        APIFetch.shared.getTopNews { [weak self] result in
           switch result {
           case .success(let articles):
               self?.articles = articles
               self?.viewModels = articles.compactMap({
                   ArticlesTableViewCellViewModel(
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
           case .failure(let error):
               print(error)
           }
       }
        // Do any additional setup after loading the view.
        
        createSearchBar()
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame =  view.bounds
    }
    
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
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
        let article = articles[indexPath.row]
        
        guard let url = URL (string: "13530") else {
            return
        }
        
        APIFetch.shared.getById(with: "13530"){ [weak self] result in
            switch result {
            case .success(let articles):
                DetailViewController(
                    title: articles.title,
                    summary: articles.summary ?? "Sem Descrição para mostrar",
                    imageURL: URL(string: articles.imageUrl ?? ""),
                    newsSite: articles.newsSite ?? "",
                    publishedAt: articles.publishedAt ?? ""
                )
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
                    ArticlesTableViewCellViewModel(
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
