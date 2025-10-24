//
//  ContentView.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderStore = ReminderStore()
    @State private var showAddReminderView: Bool = false
    
    var nextReminder: Reminder? {
        reminderStore.reminders.sorted { $0.date < $1.date }.first
    }
    
    let healthTips: [String] = [
        "Did you know? The HPV vaccine can prevent 90% of cervical cancers.",
        "Getting at least 7–8 hours of sleep supports immune function and brain health.",
        "Regular physical activity reduces your risk of heart disease and diabetes.",
        "Taking breaks from screens helps prevent eye strain and mental fatigue.",
        "Eating a balanced diet improves mood and cognitive performance."
    ]

    var dailyTip: String {
        let day = Calendar.current.component(.day, from: Date())
        return healthTips[day % healthTips.count]
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    Color(red: 0.40, green: 0.50, blue: 0.35)
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            HStack {
                                Text("Screens & Shots")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Next Reminder")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                if let next = nextReminder {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(next.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(next.date.formatted(date: .long, time: .omitted))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                } else {
                                    Text("No reminders yet.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Health Tip of the Day")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Did you know?")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text(dailyTip)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                            .padding(.horizontal)
                        } // end of vstack
                        .padding(.bottom, 40)
                        
                    } // end of scrollview
                    
                } // end of zstack
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddReminderView = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                }
                
            } // end of tab view
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            AllRemindersView(reminders: $reminderStore.reminders)
                .tabItem {
                    Label("Reminders", systemImage: "list.bullet")
                }
            
        } // end of nav stack
        .sheet(isPresented: $showAddReminderView) {
            AddReminderView(reminders: $reminderStore.reminders)
        }
    }
}

#Preview {
    ContentView()
}
