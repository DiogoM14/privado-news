import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailPublishedAt: UILabel!
    @IBOutlet var detailSummary: UILabel!
    
    static let identifier = "DetailViewController"
    var article: Article?
    var image: Data? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        registerForKeyboardNotifications()
        hideKeyboard()

        detailImage.image = UIImage(data: image!)
        detailTitle.text = article?.title
        detailSummary.text = article?.summary
        detailPublishedAt.text = article?.publishedAt
    }
    
    func hideKeyboard() {
            self.detailImage.resignFirstResponder()
            self.detailTitle.resignFirstResponder()
            self.detailSummary.resignFirstResponder()
            self.detailPublishedAt.resignFirstResponder()
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            hideKeyboard()
        }
    
    func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChange(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChange(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChange(_:)),name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
         }


        @objc func keyboardWillChange(_ notification: NSNotification) {
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
            }

            if notification.name == UIResponder.keyboardWillShowNotification ||
                notification.name == UIResponder.keyboardWillChangeFrameNotification{

                view.frame.origin.y = -keyboardRect.height
            }else {
                view.frame.origin.y = 0
            }

        }
}
