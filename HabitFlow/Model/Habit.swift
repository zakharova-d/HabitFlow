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
    private(set) var records: [Date: Bool]
    
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
    
    mutating func toggleRecord(on date: Date) {
        let currentValue = records[date] ?? false
        records[date] = !currentValue
    }
    
    func isCompleted(on date: Date) -> Bool {
        records[Calendar.current.startOfDay(for: date)] ?? false
    }
    
    func completedDaysCount(inLast days: Int) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let fromDate = calendar.date(byAdding: .day, value: -days + 1, to: today)!
        return records.filter { $0.key >= fromDate && $0.key <= today && $0.value }.count
    }
}
