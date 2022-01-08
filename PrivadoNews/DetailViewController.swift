import UIKit

class DetailViewController: UITableViewController {
    enum DetailRow: Int, CaseIterable {
        case title
        case url
        case imageUrl
        case newsSite
        case summary
        case publishedAt

        func displayText(for article: Article?) -> String {
            switch self {
            case .title:
                return article?.title ?? ""
            case .url:
                return article?.url ?? ""
            case .imageUrl:
                return article?.imageUrl ?? ""
            case .newsSite:
                return article?.newsSite ?? ""
            case .summary:
                return article?.summary ?? ""
            case .publishedAt:
                return article?.publishedAt ?? ""
            }
        }
    }

    var article: Article?

    func configure(with article: Article) {
        self.article = article
    }
}

extension DetailViewController {
    static let detailCellIdentifier = "DetailCell"

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailRow.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.detailCellIdentifier, for: indexPath)
            let row = DetailRow(rawValue: indexPath.row)
            cell.textLabel?.text = row?.displayText(for: article)
//            cell.imageView?.image = row?.cellImage
            return cell
        }
}
