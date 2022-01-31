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
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true)
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { authResult, error in
            
            if error == nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.fistnameInput.text!
                changeRequest?.commitChanges { error in
                  print("Something happened with the sign up")
                }
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessfullyRegisteredViewController") as? SuccessfullyRegisteredViewController
                else {
                    return
                }
                
                self.navigationController?.present(vc, animated: true)
            } else {
                let errCode = AuthErrorCode(rawValue: error!._code)
                switch errCode {
                case .invalidEmail:
                    self.showAlert(title: "Invalid Email", message: "Retry with a new email address")
                case .emailAlreadyInUse:
                    self.showAlert(title: "Email already registed", message: "Retry with a new email address")
                default:
                    self.showAlert(title: "Something went wrong", message: "Try again")
                }
            }
        }
    }
}
