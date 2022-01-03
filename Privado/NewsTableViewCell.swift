import UIKit

class NewsTableViewCellViewModel {
    let title : String
    let summary : String
    let imageURL : URL?
    var imageData: Data? = nil
    var newsSite: String?
    var publishedAt: String?
    
    init(
        title : String,
        summary : String,
        imageURL : URL?,
        newsSite : String,
        publishedAt : String
    ){
        self.title = title
        self.summary = summary
        self.imageURL = imageURL
        self.newsSite = newsSite
        self.publishedAt = publishedAt
    }
}

class NewsTableViewCell: UITableViewCell {
static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
//    private let authorLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .thin)
//        return label
//    }()
//    private let publishedAtLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .thin)
//        return label
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
//        contentView.addSubview(authorLabel)
//        contentView.addSubview(publishedAtLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame=CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70)
        
        subTitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width-150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10)
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
//        authorLabel.text = nil
//        publishedAtLabel.text = nil
    }
    
    func configure(with viewModel : NewsTableViewCellViewModel ){
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.summary
//        authorLabel.text = viewModel.newsSite
//        publishedAtLabel.text = viewModel.publishedAt
        
        //Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                print(data)
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
            
        }
    }

}
