import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let defaults = UserDefaults.standard
    
    static let identifier = "LoginViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        let borderColor : UIColor = UIColor(red: 0.33, green: 0.50, blue: 2.47, alpha: 1.0)
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.borderColor = borderColor.cgColor
        registerBtn.layer.cornerRadius = 5.0
        
        if defaults.bool(forKey: "First Launch") == false {
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcommingPage")
                present(view, animated: true, completion: nil)
            
            defaults.set(true, forKey: "First Launch")
        }
        
        if Auth.auth().currentUser != nil {
            navigateToMainPage()
        }
    }
    
    func navigateToMainPage() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as? MainBottomTabController
        else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true)
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
            
            if error == nil {
                self?.navigateToMainPage()
            } else {
                let errCode = AuthErrorCode(rawValue: error!._code)
                switch errCode {
                case .invalidCredential:
                    self?.showAlert(title: "Invalid credentials", message: "Email or password wrong, try again")
                case .invalidEmail:
                    self?.showAlert(title: "Invalid Email", message: "Retry with a new email address")
                default:
                    self?.showAlert(title: "Something went wrong", message: "Try again")
                }
            }
        }
    }
}
