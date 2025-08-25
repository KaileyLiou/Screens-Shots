//
//  ContentView.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var reminders: [Reminder] = []
    @State private var showAddReminderView: Bool = false
    
    var nextReminder: Reminder? {
        reminders.sorted { $0.date < $1.date }.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Next Reminder")
                        .font(.title2)
                        .fontWeight(.bold)
                    if let next = nextReminder {
                        Text("\(next.title) – \(next.date.formatted(date: .long, time: .omitted))")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    } else {
                        Text("No reminders yet.")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Text("Health Tip of the Day")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Did you know? The HPV vaccine can prevent 90% of cervical cancers.")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    

                    Text("Cybersecurity Tip of the Day")
                        .font(.title2)
                        .bold()
                    Text("Never post your vaccine card or appointment screenshot online.")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    Spacer()
                    
                } // end of vstack
                .padding()
                .navigationTitle("Screen+Secure")
                
                List(reminders) { reminder in
                    VStack(alignment: .leading) {
                        Text(reminder.title)
                            .font(.headline)
                        Text(reminder.date.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(reminder.type)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                    .navigationTitle("My Reminders")
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddReminderView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                .sheet(isPresented: $showAddReminderView) {
                    AddReminderView(reminders: $reminders)
                }
            } // end of scrollview
        } // end of nav stack

    }
}

#Preview {
    ContentView()
}
