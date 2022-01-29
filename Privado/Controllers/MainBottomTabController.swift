import Foundation
import UIKit

class MainBottomTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    }
}
