import Foundation
import UIKit


class LoginViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.33, green: 0.50, blue: 2.47, alpha: 1.0)
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.borderColor = borderColor.cgColor
        registerBtn.layer.cornerRadius = 5.0
        
    }
}
