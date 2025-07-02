//
//  Habit.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 13.06.2025.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var createdDate: Date
    var records: [Date : Bool]
    
    var isCompletedToday: Bool {
        isCompleted(on: Date())
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        createdDate: Date = Date(),
        records: [Date: Bool] = [:]
    ) {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.records = records
    }
    
    func isCompleted(on date: Date) -> Bool {
        records[Calendar.current.startOfDay(for: date)] ?? false
    }
}
