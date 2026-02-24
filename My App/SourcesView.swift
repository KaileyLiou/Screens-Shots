//
//  SourcesView.swift
//  My App
//
//  Created by Kailey Liou on 12/1/25.
//

import SwiftUI

struct SourcesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Sources")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.bottom, 10)
                        
                        SourceCard(title: "CDC Vaccine Recommendations", url: "https://www.cdc.gov/vaccines/hcp/imz-schedules/index.html")
                        SourceCard(title: "WHO Vaccination Guidelines", url: "https://www.who.int/teams/immunization-vaccines-and-biologicals")
                        SourceCard(title: "ACS Screening Guidelines", url: "https://www.cancer.org/cancer/screening/screening-recommendations-by-age.html")
                        SourceCard(title: "USPSTF A & B Recommendations", url: "https://www.uspreventiveservicestaskforce.org/uspstf/recommendation-topics/uspstf-a-and-b-recommendations")
                    }
                    .padding()
                }
            }
//            .navigationTitle("Sources")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct SourceCard: View {
    let title: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    SourcesView()
}
