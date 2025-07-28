//
//  TodayHabitsView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.06.2025.
//

import SwiftUI

struct TodayHabitsView: View {
    @State private var habitToEdit: Habit? = nil
    @State private var habitToDelete: Habit? = nil
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()
            
            if habitStore.habits.isEmpty {
                EmptyHabitsView()
            } else {
                ScrollView {
                    TodayListView(habitStore: habitStore, habitToEdit: $habitToEdit, habitToDelete: $habitToDelete)
                }
                .editSheet(for: $habitToEdit, in: habitStore)
                .deleteAlert(for: $habitToDelete, in: habitStore)
            }
        }
    }
}

private struct TodayListView: View {
    @ObservedObject var habitStore: HabitStore
    @Binding var habitToEdit: Habit?
    @Binding var habitToDelete: Habit?
    
    
    var body: some View {
        ForEach(habitStore.habits) { habit in
            TodayHabitItemView(
                habit: habit,
                isCompletedToday: habit.isCompletedToday,
                onToggle: {
                    habitStore.toggleHabit(habit)
                },
                onEdit: {
                    habitToEdit = habit
                },
                onDelete: {
                    habitToDelete = habit
                }
            )
            .padding(.vertical, 4)
            .padding(.horizontal)
        }
    }
}

#Preview("With habits") {
    TodayHabitsView(habitStore: {
        let store = HabitStore(shouldSkipLoading: true)
        store.habits = [
            Habit(title: "Drink water"),
            Habit(title: "Read a book"),
            Habit(title: "Go for a walk")
        ]
        return store
    }())
}

#Preview("Empty state") {
    TodayHabitsView(habitStore: HabitStore(shouldSkipLoading: true))
}
