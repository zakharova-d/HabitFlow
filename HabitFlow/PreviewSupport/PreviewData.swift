//
//  PreviewData.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 28.07.2025.
//


import Foundation

struct PreviewData {
    static var sampleHabits: [Habit] {
        var habit1 = Habit(title: "Drink water")
        var habit2 = Habit(title: "Walk 10k steps")
        var habit3 = Habit(title: "Read 10 pages")
        
        for i in 0..<10 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            let key = Calendar.current.startOfDay(for: date)
            if i % 2 == 0 { habit1.toggleRecord(on: key) }
            if i % 3 == 0 { habit2.toggleRecord(on: key) }
            if i % 4 == 0 { habit3.toggleRecord(on: key) }
        }
        
        return [habit1, habit2, habit3]
    }

    static func habitStoreWithSampleData() -> HabitStore {
        let store = HabitStore(shouldSkipLoading: true)
        sampleHabits.forEach { store.addHabit($0) }
        return store
    }
}
