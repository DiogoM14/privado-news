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
    
    @IBAction func handleLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainPage") as? UITabBarController
            else {
                return
            }
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        }
    }

