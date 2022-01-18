import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailPublishedAt: UILabel!
    @IBOutlet var detailSummary: UILabel!
    @IBOutlet var detailUpVote: UIButton!
    @IBOutlet var detailDownVote: UIButton!
    @IBOutlet var detailLikes: UILabel!
    @IBOutlet var detailTextView: UITextView!

    static let identifier = "DetailViewController"
    var article: Article?
    var image: Data? = nil
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        registerForKeyboardNotifications()
        hideKeyboard()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        detailTextView.layer.borderWidth = 0.5
        detailTextView.layer.borderColor = borderColor.cgColor
        detailTextView.layer.cornerRadius = 5.0
        
        let button = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
        
        detailTextView.text = "Leave your feedback here..."
        detailTextView.textColor = UIColor.lightGray
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if detailTextView.textColor == UIColor.lightGray {
                detailTextView.text = nil
                detailTextView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if detailTextView.text.isEmpty {
                detailTextView.text = "Placeholder"
                detailTextView.textColor = UIColor.lightGray
            }
        }
        
        let docId = String(article!.id)
        
        db.collection("likes").document(docId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
//                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
//                print(source)
                self.detailLikes.text = String(describing: document.get("no_likes") ?? "0")
            }


        detailImage.image = UIImage(data: image!)
        detailTitle.text = article?.title
        detailSummary.text = article?.summary
        detailPublishedAt.text = article?.publishedAt
    }
    
    @IBAction func upLikes(_ sender: Any) {
        let docId = String(article!.id)
        
        db.collection("likes").document(docId).setData([
            "no_likes": FieldValue.increment(Int64(1))
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    @IBAction func downLikes(_ sender: Any) {
        let docId = String(article!.id)
        
        db.collection("likes").document(docId).setData([
            "no_likes": FieldValue.increment(Int64(-1))
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
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
