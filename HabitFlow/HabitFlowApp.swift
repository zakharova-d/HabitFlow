//
//  HabitFlowApp.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 12.06.2025.
//

import SwiftUI

@main
struct HabitFlowApp: App {
    @StateObject private var habitStore = HabitStore()
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    ContentView(habitStore: habitStore)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.8), value: showLaunchScreen)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showLaunchScreen = false
                }
            }
        }
    }
}
