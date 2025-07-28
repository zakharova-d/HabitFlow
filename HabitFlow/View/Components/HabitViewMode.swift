//
//  HabitViewMode.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 13.06.2025.
//

import Foundation

enum HabitViewMode: String, CaseIterable {
    case today = "today"
    case weekly = "weekly"
    case progress = "progress"
}

extension HabitViewMode {
    func next() -> HabitViewMode? {
        HabitViewMode.allCases.next(after: self)
    }

    func previous() -> HabitViewMode? {
        HabitViewMode.allCases.previous(before: self)
    }
}
