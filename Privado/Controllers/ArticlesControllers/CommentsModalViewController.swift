import UIKit
import Firebase

class CommentsModalViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    static let identifier = "CommentsModalViewController"
    
    var tableViewData: [CommentModel] = []
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var docId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        db.collection("comments").document(docId).collection("comment").order(by: "timestamp", descending: false).getDocuments() {
            (querySnapshot, err) in
            if err != nil {
                    print("Error getting documents: (err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    // Converts the firebase date
                    let date = (document.get("timestamp") as! Timestamp).dateValue()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = .init(identifier: "en_POSIX")
                    dateFormatter.dateFormat = "EEEE, MMM d"
                    
                    let dateFormated = dateFormatter.string(from: date)
                            

                    self.tableViewData.append(CommentModel(
                        comment: String(describing: document.get("comment") ?? ""),
                        username: String(describing: document.get("username") ?? ""),
                        timestamp: String(describing: dateFormated)
                    ))
                }
                        
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                    
                }
            }
        }
        
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsViewCell", for: indexPath) as? CommentTableViewCell else {return UITableViewCell()}
       
        cell.commentLabel.text = self.tableViewData[indexPath.row].comment
        cell.usernameLabel.text = self.tableViewData[indexPath.row].username
        cell.timestampLabel.text = self.tableViewData[indexPath.row].timestamp
       
       return cell
    }
}
