import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    static let identifier = "LoginViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.33, green: 0.50, blue: 2.47, alpha: 1.0)
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.borderColor = borderColor.cgColor
        registerBtn.layer.cornerRadius = 5.0
        
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true)
    }
    
    @IBAction func recoverPassword(_ sender: Any) {
        
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            if error == nil {
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainPage") as? MainBottomTabController
                else {
                    return
                }
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
