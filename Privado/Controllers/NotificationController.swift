import Foundation
import UserNotifications

class NotificationController {
    static let shared = NotificationController()
    let center = UNUserNotificationCenter.current()
    
    func notification() {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Check the latest new."
        content.body = "There are a new article. Read it now"
        
        // Set the time to trigger the notification
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Request a notification
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Send the notification
        self.center.add(request) { (error) in
            if error != nil {
                print("Someting happened sendding a notification")
            }
        }
    }
}
