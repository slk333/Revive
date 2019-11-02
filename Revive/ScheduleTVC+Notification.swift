import UIKit
import UserNotifications

extension ScheduleTVC{
    
   
    // create notification content, trigger, identifier. create a notification request with it and add it to the notification center
 
    func scheduleNotification(name:String,comment:String){
           
           let content = UNMutableNotificationContent()
           content.title = name
           content.body = comment
        content.subtitle = "5 days ago"
           
           // Configure the notification date, relatively or absolutely.
           let calculatedDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
           let components = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: calculatedDate)
           
           // Create the trigger as a repeating event.
           let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
           
           // Create the request
           let uuidString = UUID().uuidString
           let request = UNNotificationRequest(identifier: uuidString,
                                               content: content, trigger: trigger)
            // queue la notification
           self.notificationCenter.add(request) { (error) in
               if error != nil {
                   // Handle any errors.
                print("big error")
                   print(error ?? "")
               }
               else{
                   print("notification queued")
               }
               
           }
           
       }
    
    
    
    
}
