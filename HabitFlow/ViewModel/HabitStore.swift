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
    // Used to skip loading from persistence (for previews / tests)
    private var shouldSkipLoading: Bool
    private let persistence: HabitPersistence

    init(shouldSkipLoading: Bool = false, persistence: HabitPersistence = UserDefaultsHabitPersistence()) {
        self.shouldSkipLoading = shouldSkipLoading
        self.persistence = persistence
        if !shouldSkipLoading {
            loadHabits()
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        log("New habit created: \(habit.title)")
        saveHabits()
    }
    
    func toggleHabit(_ habit: Habit, on date: Date = Date()) {
        guard let index = index(of: habit) else { return }
        var updatedHabit = habits[index]
        let currentValue = updatedHabit.records[date] ?? false
        updatedHabit.toggleRecord(on: date)
        habits[index] = updatedHabit
        saveHabits()
        log("Habit '\(habit.title)' marked as \(!currentValue ? "done ✅" : "not done ❌") at \(date)")
    }
    
    func editHabit(_ updatedHabit: Habit) {
        if let index = index(of: updatedHabit) {
            let oldHabit = habits[index]
            habits[index] = updatedHabit
            saveHabits()
            log("Edited habit: '\(oldHabit.title)' -> '\(updatedHabit.title)'")
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        if let index = index(of: habit) {
            habits.remove(at: index)
            saveHabits()
            log("Deleted habit: '\(habit.title)'")
        }
    }
    
    private func index(of habit: Habit) -> Int? {
        return habits.firstIndex(where: { $0.id == habit.id })
    }
    
    private func saveHabits() {
        persistence.save(habits)
        log("Habits saved succesfully")
    }

    private func loadHabits() {
        self.habits = persistence.load()
        log("Habits loaded succesfully")
    }
    
    private func log(_ message: String) {
        print("[HabitStore] \(message)")
    }
}
