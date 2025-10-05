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
        "Drinking water regularly throughout the day helps improve energy and focus.",
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
                    Color(red: 0.98, green: 0.96, blue: 0.92)
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                                Text("Screens & Shots")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding()
                            }
                            .frame(height: 80)
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Next Reminder")
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                if let next = nextReminder {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(next.title)
                                            .font(.headline)
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
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                            
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Health Tip of the Day")
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Did you know?")
                                        .font(.headline)

                                    Text(dailyTip)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)

//                            Text("Health Tip of the Day")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Did you know? The HPV vaccine can prevent 90% of cervical cancers.")
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(10)
//                            
//                            Text("Cybersecurity Tip of the Day")
//                                .font(.title2)
//                                .bold()
//                            Text("Never post your vaccine card or appointment screenshot online.")
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(10)
                            
                        } // end of vstack
                        .padding()
                    } // end of scrollview
                } // end of zstack
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddReminderView = true
                        } label: {
                            Image(systemName: "plus")
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
