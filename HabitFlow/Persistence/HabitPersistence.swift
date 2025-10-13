//
//  HabitPersistence.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 25.07.2025.
//

import CoreData

protocol HabitPersistence {
    func save(_ habits: [Habit])
    func delete(_ habit: Habit)
    func load() -> [Habit]
}
