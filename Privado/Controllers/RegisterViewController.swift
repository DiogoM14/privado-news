import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var fistnameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { authResult, error in
            
            if error == nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.fistnameInput.text!
                changeRequest?.commitChanges { error in
                  // ...
                }
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessfullyRegisteredViewController") as? SuccessfullyRegisteredViewController
                else {
                    return
                }
                
                self.navigationController?.present(vc, animated: true)
            }
        }
    }
}
