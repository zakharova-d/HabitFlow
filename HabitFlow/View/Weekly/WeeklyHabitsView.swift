//
//  WeeklyHabitsView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.07.2025.
//

import SwiftUI

struct WeeklyHabitsView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var habitToEdit: Habit? = nil
    @State private var habitToDelete: Habit? = nil
    
    var body: some View {
        ZStack{
            Color(Color(AppColor.background))
                .ignoresSafeArea()
            if habitStore.habits.isEmpty {
                EmptyHabitsView()
            } else {
                ScrollView {
                    WeeklyListView(habitStore: habitStore,
                                   habitToEdit: $habitToEdit,
                                   habitToDelete: $habitToDelete)
                }
                .editSheet(for: $habitToEdit, in: habitStore)
                .deleteAlert(for: $habitToDelete, in: habitStore)
            }
        }
    }
}

private struct WeeklyListView: View {
    @ObservedObject var habitStore: HabitStore
    @Binding var habitToEdit: Habit?
    @Binding var habitToDelete: Habit?
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(habitStore.habits) { habit in
                WeeklyHabitItemView(
                    habit: habit,
                    dates: Date.last7Days,
                    toggleAction: { date in
                        habitStore.toggleHabit(habit, on: date)
                    },
                    onEdit: {
                        habitToEdit = habit
                    },
                    onDelete: {
                        habitToDelete = habit
                    }
                )
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
    }
}

extension Date {
    static var last7Days: [Date] {
        let today = Calendar.current.startOfDay(for: Date())
        return (0..<7).map { offset in
            Calendar.current.date(byAdding: .day, value: -6 + offset, to: today)!
        }
    }
}

struct WeeklyHabitsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockHabits = [
            Habit(title: "Drink Water", createdDate: Date().addingTimeInterval(-86400 * 10), records: [
                Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400 * 1)): true,
                Calendar.current.startOfDay(for: Date()): true
            ]),
            Habit(title: "Read Book", createdDate: Date().addingTimeInterval(-86400 * 10), records: [
                Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400 * 2)): true
            ]),
            Habit(title: "Meditate", createdDate: Date().addingTimeInterval(-86400 * 10))
        ]
        let mockStore = HabitStore(shouldSkipLoading: true)
        mockStore.habits = mockHabits
        
        return WeeklyHabitsView(habitStore: mockStore)
    }
}
