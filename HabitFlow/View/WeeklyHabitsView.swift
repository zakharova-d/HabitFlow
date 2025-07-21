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
    
    private var last7Days: [Date] {
        let today = Calendar.current.startOfDay(for: Date())
        return (0..<7).map { offset in
            Calendar.current.date(byAdding: .day, value: -6 + offset, to: today)!
        }
    }
    
    var body: some View {
        ZStack{
            Color(Color(AppColor.background))
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(habitStore.habits) { habit in
                        WeeklyHabitItemView(
                            habit: habit,
                            dates: last7Days,
                            toggleAction: { date in
                                habitStore.toggleCompletion(for: habit, on: date)
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
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .editSheet(for: $habitToEdit, in: habitStore)
                .deleteAlert(for: $habitToDelete, in: habitStore)
            }
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
        let mockStore = HabitStore(skipLoading: true)
        mockStore.habits = mockHabits
        
        return WeeklyHabitsView(habitStore: mockStore)
    }
}
