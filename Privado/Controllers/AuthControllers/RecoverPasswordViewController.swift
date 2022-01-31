import Foundation
import UIKit
import Firebase

class RecoverPasswordViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleRecoverPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: textField.text!) { error in
            print(error ?? "Something happened recovering the password.")
        }
    }
}
