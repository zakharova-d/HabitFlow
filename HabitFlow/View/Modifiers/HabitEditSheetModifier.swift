//
//  HabitEditSheetModifier.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 16.07.2025.
//

import SwiftUI

struct HabitEditSheetModifier: ViewModifier {
    @Binding var habitToEdit: Habit?
    let habitStore: HabitStore

    func body(content: Content) -> some View {
        content.sheet(item: $habitToEdit) { habit in
            AddHabitView(
                habitToEdit: habit,
                onAddHabit: { _ in },
                onUpdateHabit: { updatedHabit in
                    habitStore.editHabit(updatedHabit)
                }
            )
        }
    }
}

extension View {
    func editSheet(for habitToEdit: Binding<Habit?>, in habitStore: HabitStore) -> some View {
        self.modifier(HabitEditSheetModifier(habitToEdit: habitToEdit, habitStore: habitStore))
    }
}
