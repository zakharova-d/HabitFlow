//
//  LaunchScreenView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 30.07.2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()
            
            VStack {
                Image(AppImage.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .opacity(logoOpacity)
                    .scaleEffect(logoOpacity == 1.0 ? 1.0 : 0.8)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
                            logoOpacity = 1.0
                        }
                    }
                
                Text(Bundle.main.appName)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.top, 16)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
                            textOpacity = 1.0
                        }
                    }
            }
        }
    }
}
