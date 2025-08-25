//
//  AllRemindersView.swift
//  My App
//
//  Created by Kailey Liou on 8/24/25.
//

import SwiftUI

struct AllRemindersView: View {
    @Binding var reminders: [Reminder]
    
    var body: some View {
        NavigationStack {
            List(reminders) { reminder in
                VStack(alignment : .leading) {
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
            }
            .navigationTitle(Text("All Reminders"))
        }
    }
}

#Preview {
    AllRemindersView()
}
