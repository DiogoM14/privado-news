import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        usernameLabel.text = Auth.auth().currentUser!.displayName

        var test = Auth.auth().currentUser?.photoURL
        
        if test == nil {
            test = URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png")
        }
        
        URLSession.shared.dataTask(with: test!) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }

            DispatchQueue.main.async {
                self?.avatar.image = UIImage(data: data)
            }
        }.resume()
        
 
    }
    
    @IBAction func handleSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error ao deslogar")
        }
    }
}
