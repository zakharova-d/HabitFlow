//
//  HabitEditSheetModifier.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 16.07.2025.
//


import SwiftUI

// MARK: - Habit Edit Sheet Modifier

struct HabitEditSheetModifier: ViewModifier {
    @Binding var habitToEdit: Habit?
    let habitStore: HabitStore

    func body(content: Content) -> some View {
        content.sheet(item: $habitToEdit) { habit in
            AddHabitView(
                habitToEdit: habit,
                onSave: { _ in },
                onEdit: { updatedHabit in
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

// MARK: - Habit Delete Alert Modifier

struct HabitDeleteAlertModifier: ViewModifier {
    @Binding var habitToDelete: Habit?
    let habitStore: HabitStore

    func body(content: Content) -> some View {
        content.alert(item: $habitToDelete) { habit in
            Alert(
                title: Text("Delete Habit"),
                message: Text("Are you sure you want to delete \"\(habit.title)\"?"),
                primaryButton: .destructive(Text("Delete")) {
                    habitStore.deleteHabit(habit)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

extension View {
    func deleteAlert(for habitToDelete: Binding<Habit?>, in habitStore: HabitStore) -> some View {
        self.modifier(HabitDeleteAlertModifier(habitToDelete: habitToDelete, habitStore: habitStore))
    }
}
