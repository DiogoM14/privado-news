import Foundation
import UIKit
import Firebase

class RecoverPasswordViewController: UIViewController {
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: passwordInput.text!) { error in
            print(error)
        }
    }
}
