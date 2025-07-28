//
//  HabitProgressView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 09.07.2025.
//


import SwiftUI

struct ProgressHabitsView: View {
    @ObservedObject var habitStore: HabitStore
    @State var selectedPeriod: Int = 30
    let availablePeriods = [30, 60, 90]
    @State private var habitToEdit: Habit? = nil
    @State private var habitToDelete: Habit? = nil
    
    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()
            
            if habitStore.habits.isEmpty {
                EmptyHabitsView()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        PeriodPickerView(selectedPeriod: $selectedPeriod, availablePeriods: availablePeriods)
                        
                        ProgressListView(habitStore: habitStore,
                                         selectedPeriod: $selectedPeriod, habitToEdit: $habitToEdit, habitToDelete: $habitToDelete)
                        .editSheet(for: $habitToEdit, in: habitStore)
                        .deleteAlert(for: $habitToDelete, in: habitStore)
                    }
                }
            }
        }
    }
}

private struct ProgressListView: View {
    @ObservedObject var habitStore: HabitStore
    @Binding var selectedPeriod: Int
    @Binding var habitToEdit: Habit?
    @Binding var habitToDelete: Habit?
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(habitStore.habits) { habit in
                let done = habit.completedDaysCount(inLast: selectedPeriod)
                ProgressHabitItemView(
                    habitTitle: habit.title,
                    completedDaysCount: done,
                    totalDaysInPeriod: selectedPeriod,
                    onEdit: {
                        habitToEdit = habit
                    },
                    onDelete: {
                        habitToDelete = habit
                    }
                )
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

private struct PeriodPickerView: View {
    @Binding var selectedPeriod: Int
    let availablePeriods: [Int]

    var body: some View {
        HStack(spacing: 24) {
            ForEach(availablePeriods, id: \.self) { period in
                VStack(spacing: 4) {
                    Text("\(period) days")
                        .font(.headline)
                        .foregroundColor(selectedPeriod == period ? AppColor.strongGreen : .secondary)
                        .onTapGesture {
                            selectedPeriod = period
                        }
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(selectedPeriod == period ? AppColor.green : .clear)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}

#Preview("With progress") {
    let store = HabitStore(shouldSkipLoading: true)
    store.habits = [
        Habit(title: "Read a Book", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 2 == 0
        }),
        Habit(title: "Meditate", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 3 == 0
        }),
        Habit(title: "Walk", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = true
        })
    ]
    let selectedPeriod = Binding<Int>(get: { 90 }, set: { _ in })
    return ProgressHabitsView(habitStore: store)
}

#Preview("No progress") {
    let store = HabitStore(shouldSkipLoading: true)
    store.habits = [
        Habit(title: "Read a Book"),
        Habit(title: "Meditate"),
        Habit(title: "Walk")
    ]
    let selectedPeriod = Binding<Int>(get: { 30 }, set: { _ in })
    return ProgressHabitsView(habitStore: store)
}
