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

extension Array where Element: Equatable {
    func next(after element: Element) -> Element? {
        guard let index = firstIndex(of: element), index + 1 < count else { return nil }
        return self[index + 1]
    }

    func previous(before element: Element) -> Element? {
        guard let index = firstIndex(of: element), index - 1 >= 0 else { return nil }
        return self[index - 1]
    }
}
