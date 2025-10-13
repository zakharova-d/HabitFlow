//
//  HabitStore.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.06.2025.
//


import Foundation
import SwiftUI
import RealmSwift

class HabitStore: ObservableObject {
    // MARK: - Published Properties
    @Published var habits: [Habit] = [] // Current list of habits

    // MARK: - Private Properties
    private var shouldSkipLoading: Bool // Used to skip loading (for previews or tests)
    private let persistence: HabitPersistence
    private var notificationToken: NotificationToken? // Realm notification token

    // MARK: - Initialization
    init(shouldSkipLoading: Bool = false, persistence: HabitPersistence = RealmHabitPersistence()) {
        self.shouldSkipLoading = shouldSkipLoading
        self.persistence = persistence
        if !shouldSkipLoading {
            loadHabits()        // Load initial habits from persistence
        }
    }

    // MARK: - Public Methods (CRUD)
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        log("New habit created: \(habit.title)")
        saveHabits()
    }
    
    func toggleHabit(_ habit: Habit, on date: Date = Date().startOfDay) {
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
    
    // MARK: - Private Helpers
    private func index(of habit: Habit) -> Int? {
        return habits.firstIndex(where: { $0.id == habit.id })
    }
    
    private func saveHabits() {
        persistence.save(habits)
        log("Habits saved successfully")
    }


    private func loadHabits() {
        self.habits = persistence.load()
        log("Habits loaded successfully")
    }
    
    private func log(_ message: String) {
        print("[HabitStore] \(message)")
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
