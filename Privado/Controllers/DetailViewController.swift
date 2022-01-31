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
    @IBOutlet var submitComment: UIButton!
    @IBOutlet var seeMoreComments: UIButton!
    

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
        
        let button = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(openQRCodeModal))
        navigationItem.rightBarButtonItem = button
        
//        submitComment.addTarget(self, action: #selector(seeMoreComments), for: .touchUpInside)
        
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
        detailPublishedAt.text = convertDateFormater(article?.publishedAt)
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
    
    @IBAction func submitComment(_ sender: UIButton) {
        let docId = String(article!.id)
        
        db.collection("comments").document(docId).collection("comment").addDocument(data: [
            "comment": String(detailTextView.text),
            "username": String(Auth.auth().currentUser?.displayName ?? ""),
            "timestamp": FieldValue.serverTimestamp()
        ])
    }
    
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
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
        notification.name == UIResponder.keyboardWillChangeFrameNotification {

            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }

    }
    
    @objc func openQRCodeModal() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "QRCodeModal") as? QRModalViewController
        else {
            return
        }
        
        vc.articleURL = article?.url ?? ""
        
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func seeMoreComments(_ sender: UIButton) {
        let docId = String(article!.id)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsModalViewController") as? CommentsModalViewController
        else {
            return
        }
        
        vc.docId = docId
        
        navigationController?.present(vc, animated: true)
    }
}
