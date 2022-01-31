import UIKit
import Firebase

class CommentsModalViewController: UIViewController, UITableViewDataSource {
    var tableViewData: [CommentModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    static let identifier = "CommentsModalViewController"
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var docId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        db.collection("comments").document(docId).collection("comment").getDocuments() {
            (querySnapshot, err) in
            if err != nil {
                    print("Error getting documents: (err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.get("timestamp") as! Timestamp
                        let date = data.dateValue()

                        self.tableViewData.append(CommentModel(
                            comment: String(describing: document.get("comment") ?? ""),
                            username: String(describing: document.get("username") ?? ""),
                            timestamp: String(describing: date)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
