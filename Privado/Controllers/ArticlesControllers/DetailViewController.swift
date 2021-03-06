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
    var likes: Int = 0
    var dislike: Int = 0
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.hideKeyboardWhenTappedAround()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        detailTextView.layer.borderWidth = 0.5
        detailTextView.layer.borderColor = borderColor.cgColor
        detailTextView.layer.cornerRadius = 5.0
        
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareArticle))
        navigationItem.rightBarButtonItem = button
        
        let docId = String(article!.id)
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("likes").document(docId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }

                self.detailLikes.text = String(describing: document.get("no_likes") ?? "0")
            }
        
        db.collection("userLikes").document(String(describing: userId!)).collection("articleId").document(docId)
            .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
                
            if document.get("like") != nil {
                self.likes = document.get("like") as! Int
            }
                
            if document.get("dislike") != nil {
                self.dislike = document.get("dislike") as! Int
            }
        }

        detailImage.image = UIImage(data: image!)
        detailTitle.text = article?.title
        detailSummary.text = article?.summary
        detailPublishedAt.text = DateConverter.convertDateFormater(article?.publishedAt)
    }
    
    @IBAction func upLikes(_ sender: Any) {
        let docId = String(article!.id)
        let userId = Auth.auth().currentUser?.uid
        
        if likes == 0 && dislike == 1 {
            db.collection("userLikes").document(String(describing: userId!)).collection("articleId").document(docId).setData([
                "dislike": 0,
            ], merge: true)
            
            db.collection("likes").document(docId).setData([
                "no_likes": FieldValue.increment(Int64(1))
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        } else if likes == 0 && dislike == 0 {
            db.collection("userLikes").document(String(describing: userId!)).collection("articleId").document(docId).setData([
                "like": 1,
            ], merge: true)
            
            db.collection("likes").document(docId).setData([
                "no_likes": FieldValue.increment(Int64(1))
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        }
    }
    
    @IBAction func downLikes(_ sender: Any) {
        let docId = String(article!.id)
        let userId = Auth.auth().currentUser?.uid
        
        if likes == 1 && dislike == 0 {
            db.collection("userLikes").document(String(describing: userId!)).collection("articleId").document(docId).setData([
                "like": 0,
            ], merge: true)
            
            db.collection("likes").document(docId).setData([
                "no_likes": FieldValue.increment(Int64(-1))
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        } else if likes == 0 && dislike == 0 {
            db.collection("userLikes").document(String(describing: userId!)).collection("articleId").document(docId).setData([
                "dislike": 1,
            ], merge: true)
            
            db.collection("likes").document(docId).setData([
                "no_likes": FieldValue.increment(Int64(-1))
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
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
    
    @IBAction func openQRCodeModal(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "QRCodeModal") as? QRModalViewController
        else {
            return
        }

        vc.articleURL = article?.url ?? ""

        navigationController?.present(vc, animated: true)
    }
    
    @objc func shareArticle() {
        guard let image = image, let url = URL(string: (article?.url)!) else {
            return
        }
        let shareSheetvc = UIActivityViewController(
            activityItems: [
                image,
                url
            ],
            applicationActivities: nil
        )

        present(shareSheetvc, animated: true)
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
