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

    var body: some Scene {
        WindowGroup {
            ContentView(habitStore: habitStore)
        }
    }
}
