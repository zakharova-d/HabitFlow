//
//  HabitDeleteAlertModifier.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 25.07.2025.
//

import SwiftUI

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
