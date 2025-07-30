//
//  RealmHabit.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 29.07.2025.
//

import Foundation
import RealmSwift

class RealmHabit: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var title: String
    @Persisted var records: Map<String, Bool>

    // MARK: - Mapping

    /// Creates a RealmHabit from a Habit
    static func from(_ habit: Habit) -> RealmHabit {
        let realmHabit = RealmHabit()
        realmHabit.id = habit.id
        realmHabit.title = habit.title
        
        // Converts [Date: Bool] to [String: Bool]
        for (date, done) in habit.records {
            realmHabit.records[date.toKey()] = done
        }
        return realmHabit
    }

    /// Converts back to a Habit
    func toHabit() -> Habit {
        var recordsDict: [Date: Bool] = [:]
        for entry in records {
            if let date = Date.fromKey(entry.key) {
                recordsDict[date] = entry.value
            }
        }
        return Habit(id: id, title: title, records: recordsDict)
    }
}

import Foundation

extension Date {
    /// Converts a date to a String key (ISO8601)
    func toKey() -> String {
        ISO8601DateFormatter().string(from: self)
    }

    /// Restores a date from a String key
    static func fromKey(_ key: String) -> Date? {
        ISO8601DateFormatter().date(from: key)
    }
}
