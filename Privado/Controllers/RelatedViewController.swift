import UIKit
import SafariServices

class RelatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [ArticlesTableViewCellViewModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ISS"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        APIFetch.shared.getIssDiary { [weak self] result in
           switch result {
           case .success(let articles):
               self?.articles = articles
               self?.viewModels = articles.compactMap({
                   ArticlesTableViewCellViewModel(
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
           case .failure(let error):
               print(error)
           }
       }
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
        APIFetch.shared.getIssDiary { [weak self] result in
           switch result {
           case .success(let articles):
               self?.articles = articles
               self?.viewModels = articles.compactMap({
                   ArticlesTableViewCellViewModel(
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
           case .failure(let error):
               print(error)
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
}
