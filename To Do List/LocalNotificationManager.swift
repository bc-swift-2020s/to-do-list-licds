//
//  LocalNotificationManager.swift
//  To Do List
//
//  Created by Yi Li on 3/9/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
    static func authorizeLocalNotifications(viewController: UIViewController){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("notification authorization granted")
            } else {
                print("User Denied Authorization")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "Notifications Not Allowed", message: "Change that in the settings app")
                }
                
            }
        }
    }
    
    static func isAuthorized(completed: @escaping (Bool)->()){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                completed(false)
                return
            }
            if granted {
                print("notification authorization granted")
                completed(true)
            } else {
                print("User Denied Authorization")
                completed(false)
                }
                
            }
        }
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription) Yikes, adding notification request went wrong")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
}

