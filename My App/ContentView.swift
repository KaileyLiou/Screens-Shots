//
//  ContentView.swift
//  My App
//
//  Created by Kailey Liou on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Next Reminder")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("HPV Vaccine – Aug 27, 2025 at 10:00 AM")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
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
            } // end of scrollview
        } // end of nav stack

    }
}

#Preview {
    ContentView()
}
