import UIKit

class WelcommingViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Launch") == true {
            print("second")
            
            defaults.set(true, forKey: "First Launch")
        } else {
            print("first")
            defaults.set(true, forKey: "First Launch")
        }
    }
}
