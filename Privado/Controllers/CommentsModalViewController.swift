import UIKit
import Firebase

class CommentsModalViewController: UIViewController, UITableViewDataSource {
    var tableViewData: [String] = []
    
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
                if let err = err {
                    print("Error getting documents: (err)")
                } else {
                    for document in querySnapshot!.documents {
                        var teste = String(describing: document.get("comment")!)
                        print(teste)
                        self.tableViewData.append(teste)
                        print(self.tableViewData)
                        
                }
                            
                    DispatchQueue.main.async {
                       self.tableView.reloadData()
                        
                    }
                }
        }
            
//        db.collection("comments").document(docId).collection("comment")
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                for document in querySnapshot!.documents {
//                       print("\(document.documentID) => \(document.data()) ====", document.get("comentario") as! String)
//               }
//
//                self.tableViewData = String(describing: document.get("comment") ?? "0")
//                print(self.tableViewData)
//
//                DispatchQueue.main.async {
//                   self.tableView.reloadData()
//                }
//            }
        
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.tableViewData[indexPath.row]
        return cell
    }
}
