//
//  NotificationsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-18.
//

import SwiftUI

struct NotificationsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var calendarManager: CalendarManager
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.appBlue)
                        Text("Back")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
                
                Text("Notifications")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(width: 60)
            }
            
           
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    let todayNotifications = calendarManager.reminders.filter { Calendar.current.isDateInToday($0.date) }
                    let yesterdayNotifications = calendarManager.reminders.filter { Calendar.current.isDateInYesterday($0.date) }
                    
                    if !todayNotifications.isEmpty {
                        sectionView(title: "Today", notifications: todayNotifications)
                    }
                    
                    if !yesterdayNotifications.isEmpty {
                        sectionView(title: "Yesterday", notifications: yesterdayNotifications)
                    }
                    
                    if todayNotifications.isEmpty && yesterdayNotifications.isEmpty {
                        Text("No notifications yet")
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    
    private func sectionView(title: String, notifications: [MealReminder]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.sfProMedium(size: 14))
                .foregroundColor(.appWhite)
            
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            ForEach(notifications) { notification in
                notificationCard(reminder: notification)
            }
        }
    }
    
    
    private func notificationCard(reminder: MealReminder) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "bell.fill")
                .foregroundColor(.appWhite)
                .font(.system(size: 20))
                .frame(width: 20, height: 20)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Meal Reminder")
                    .font(.sfProMedium(size: 16))
                    .foregroundColor(.appWhite)
                
                Text("\(reminder.title) – Reminder at \(reminder.formattedDate)")
                    .font(.sfProRegular(size: 14))
                    .foregroundColor(.appWhite)
                
                Text(reminder.formattedDate)
                    .font(.sfProRegular(size: 12))
                    .foregroundColor(.appWhite.opacity(0.7))
            }
            
            Spacer()
        }
        .frame(width: 320, height: 100)
        .padding()
        .background(Color.appWhite.opacity(0.3))
        .cornerRadius(12)
        .frame(maxWidth: .infinity, alignment: .center)
    }

        
        
    
}

#Preview {
    NotificationsView()
}
