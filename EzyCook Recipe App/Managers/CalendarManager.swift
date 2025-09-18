//
//  CalendarManager.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-18.
//

import Foundation
import SwiftUI
import EventKit
import UserNotifications

class CalendarManager : ObservableObject {
    
    static let shared = CalendarManager()
    @Published var reminders: [MealReminder] = []
    private let eventStore = EKEventStore()
    
   
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied or error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
   
    private func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        if status == .notDetermined {
            eventStore.requestAccess(to: .event) { granted, _ in
                DispatchQueue.main.async { completion(granted) }
            }
        } else if status == .authorized || (status == .fullAccess || status == .writeOnly) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    
    func addMealEvent(title: String, date: Date, completion: ((Bool, Error?) -> Void)? = nil) {
        requestCalendarAccess { granted in
            guard granted else {
                completion?(false, nil)
                print("Calendar access denied")
                return
            }
            
            let event = EKEvent(eventStore: self.eventStore)
            event.title = title
            event.startDate = date
          //  event.endDate = date.addingTimeInterval(30 * 60) // 30 min
            event.endDate = date.addingTimeInterval(10) // test
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
                print("Event added to calendar: \(title)")
                
                
                DispatchQueue.main.async {
                    let reminder = MealReminder(title: title, date: date)
                    self.reminders.append(reminder)
                }
                
                
                self.scheduleNotification(title: title, date: date)
                
                completion?(true, nil)
            } catch {
                print("Failed to add event: \(error)")
                completion?(false, error)
            }
        }
    }
    
    
    private func scheduleNotification(title: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Meal Reminder"
        content.body = title
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        
       let beforeDate = date.addingTimeInterval(-10 * 60)
        //let beforeDate = date.addingTimeInterval(5)
        if beforeDate > Date() {
            let beforeTriggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: beforeDate)
            let beforeTrigger = UNCalendarNotificationTrigger(dateMatching: beforeTriggerDate, repeats: false)
            
            let beforeRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: beforeTrigger)
            UNUserNotificationCenter.current().add(beforeRequest)
        }
    }


    
}






