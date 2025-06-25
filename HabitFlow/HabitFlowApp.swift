//
//  HabitFlowApp.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 12.06.2025.
//

import SwiftUI

@main
struct HabitFlowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(habitStore: HabitStore())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
