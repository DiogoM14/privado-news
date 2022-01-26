import UIKit

class QRModalViewController: UIViewController {

    @IBOutlet var qrCodeImage: UIImageView!
    
    static let identifier = "QRCodeModal"
    var articleURL: String!
    
    let url = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let test = URL(string: url + articleURL)
        
        
        URLSession.shared.dataTask(with: test!) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async {
                self?.qrCodeImage.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
    
}
