import UIKit
import SafariServices

let imageCache = NSCache<AnyObject, AnyObject>()

class ArticleListViewController: UITableViewController {
    static let showDetailSegueIdentifier = "ShowDetailSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
            let destination = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let article = APIFetch.testData[indexPath.row]
            destination.configure(with: article)
        }
    }
}

extension ArticleListViewController {
    static let articleListCellIdentifier = "ArticleListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIFetch.testData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.articleListCellIdentifier, for: indexPath) as? ArticleListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        
//        APIFetch.shared.getTopNews { result in
//        switch result {
//            case .success(let article):
//            self.article = Article
//                cell.siteLabel.text = article.title
//                cell.summaryLabel.text = article.summary
//                cell.uploadDateLabel.text = article.publishedAt
//                cell.imageFrame = image
//            case .failure:
//                print("ardeu")
//            }
//        }
        
        let article = APIFetch.testData[indexPath.row]
    
        // OUTPUT DO PRINT -> Optional("https://swiftdeveloperblog.com/wp-content/uploads/2015/07/1.jpeg")
        cell.siteLabel.text = article.newsSite
        cell.summaryLabel.text = article.summary
        cell.uploadDateLabel.text = article.publishedAt
//        cell.imageFrame = (article.imageUrl)
        
        return cell
    }
}

