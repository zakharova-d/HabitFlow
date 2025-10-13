//
//  UserDefaultsHabitPersistence.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 25.07.2025.
//

import Foundation


class UserDefaultsHabitPersistence: HabitPersistence {
    private let habitsKey = "savedHabits"

    func save(_ habits: [Habit]) {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
    }
    
    func delete(_ habit: Habit) {
        var habits = load()
        habits.removeAll { $0.id == habit.id }
        save(habits)
    }

    func load() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: habitsKey),
              let decoded = try? JSONDecoder().decode([Habit].self, from: data) else {
            return []
        }
        return decoded
    }
}
