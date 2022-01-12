import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailSummary: UILabel!
    @IBOutlet var detailPublishedAt: UILabel!
    
    static let identifier = "DetailViewController"
    var article: Article?
    var image: Data? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground


        detailImage.image = UIImage(data: image!)
        detailTitle.text = article?.title
        detailSummary.text = article?.summary
        detailPublishedAt.text = article?.publishedAt
    }
}
