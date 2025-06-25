//
//  HabitStore.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.06.2025.
//


import Foundation
import SwiftUI

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    private let habitsKey = "savedHabits"

    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        print("New habit created: \(habit.title)")
        saveHabits()
    }
    
    func toggleCompletion(for habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        let today = Calendar.current.startOfDay(for: Date())
        var updatedHabit = habits[index]
        let currentValue = updatedHabit.records[today] ?? false
        updatedHabit.records[today] = !currentValue
        habits[index] = updatedHabit
        
        print("Habit '\(habit.title)' marked as \(!currentValue ? "done ✅" : "not done ❌")")
    }
    
    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
            print("Habits saved successfully")
        }
    }

    func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decoded
            print("Habits loaded: \(habits.count) total")
        }
    }
    
    // MARK: - Future Extensions

    // TODO: Consider adding explicit methods for setting completion status:
    // func markHabitDone(_ habit: Habit)
    // func markHabitUndone(_ habit: Habit)
}
