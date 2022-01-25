import UIKit

class WelcommingViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        handlePermissionForNotifications()
        
        if defaults.bool(forKey: "First Launch") == true {
            print("second")
            
            defaults.set(true, forKey: "First Launch")
        } else {
            print("first")
            defaults.set(true, forKey: "First Launch")
        }
    }
    
    func handlePermissionForNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            // Handle the error here.
            print(error)
        }
        // Enable or disable features based on the authorization.
        print(granted)
    }
    }
}
