//
//  SplashView.swift
//  My App
//
//  Created by Kailey Liou on 2/23/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.background.ignoresSafeArea()
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(isActive ? 0 : 1)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
