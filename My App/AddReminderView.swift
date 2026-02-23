//
//  AddReminderView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var reminderStore: ReminderStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var type = "Vaccine"
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.92)
                    .ignoresSafeArea()
                
                VStack {
                    Text("New Reminder")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        TextField("Enter reminder title", text: $title)
                            .padding()
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .cornerRadius(10)
                        
                        DatePicker("Select Date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        Picker("Reminder Type", selection: $type) {
                            Text("Vaccine").tag("Vaccine")
                            Text("Screening").tag("Screening")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        let newReminder = Reminder(title: title, date: date, type: type)
                        reminderStore.addIfUnique(newReminder)
                        NotificationManager.scheduleNotification(for: newReminder)
                        dismiss()
                    }) {
                        Text("Save Reminder")
                            .fontWeight(.bold)
                            .frame(maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .background(canSave ? Color.accentGreen : Color.gray)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .disabled(!canSave)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.black.opacity(0.8))
                }
            }
        }
    }
}

#Preview {
    AddReminderView(reminderStore: ReminderStore())
}
