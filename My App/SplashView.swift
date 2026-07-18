//
//  SplashView.swift
//  My App
//
//  Created by Kailey Liou on 2/23/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // this bumps the logo up a bit on ipad instead of it looking tiny and lost on the much bigger screen
    private var logoSize: CGFloat {
        horizontalSizeClass == .regular ? 220 : 150
    }

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.background.ignoresSafeArea()
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)
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
