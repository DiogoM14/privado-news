import UIKit

class ArticlesTableViewCell: UITableViewCell {
    static let identifier = "ArticlesTableViewCell"
    
    private let newsSiteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let newsPublishedAt: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
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
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsSiteLabel)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsPublishedAt)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsSiteLabel.frame=CGRect(
            x: 16,
            y: 248,
            width: contentView.frame.size.width,
            height: 70)
        
        newsTitleLabel.frame=CGRect(
            x: 16,
            y: 205,
            width: contentView.frame.size.width,
            height: 70)
        
        subTitleLabel.frame = CGRect(
            x: 16,
            y: 200,
            width: contentView.frame.size.width,
            height: 200)
        
        newsImageView.frame = CGRect(
            x: 16,
            y: 5,
            width: contentView.frame.size.width,
            height: 200)
        
        newsPublishedAt.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 248,
            width: contentView.frame.size.width - 200,
            height: 70)
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        newsSiteLabel.text = nil
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
        newsPublishedAt.text = nil
    }
    
    func configure(with viewModel : ArticlesTableViewCellViewModel ){
        newsTitleLabel.text = viewModel.title
        newsSiteLabel.text = viewModel.newsSite
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "pt_BR")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         
        let date = RFC3339DateFormatter.date(from: viewModel.publishedAt)
        
        let test = String(describing: date!)
        newsPublishedAt.text = test
        //        newsPublishedAt.text = "1d"
        
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
