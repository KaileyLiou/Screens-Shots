//
//  AddReminderView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AddReminderView: View {
    @State private var title = ""
    @State private var date = Date()
    @State private var type = "Vaccine"
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Enter reminder title", text: $title)
                DatePicker("Select Date", selection: $date, displayedComponents: .date)
                
                Picker("Reminder Type", selection: $type) {
                    Text("Vaccine").tag("Vaccine")
                    Text("Screening").tag("Screening")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Save Reminder") {
                    print("Saved Reminder")
                }
            }
            .navigationTitle("New Reminder")
        }
    }
}

#Preview {
    AddReminderView()
}
